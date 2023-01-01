require 'simulation'
require 'table_print'

# `rails simulate:season`             --> generate odds and play all matchups
# `rails simulate:season picks=true`  --> additionally run simulated user picks
# 
# Database must already be seeded for this to work.
# Simulations are run in virtual memory and output to console; nothing stored in the db.

namespace :simulate do
  desc 'Simulate odds and results for an entire season'
  task season: :environment do
    include Simulation

    # arg passed to run user pick simulations?
    simulate_picks = ENV["picks"].to_s.downcase == "true"

    # group simulated matchups by week
    matchup_weeks = SimMatchup.order(:week_id).group_by{|sm| sm.week_id.to_s }

    # templatize a hash of data for each team per week
    team_data = Team.all.map do |team|
      [team.id.to_s, {}]
    end.to_h

    # store a copy of last week's results
    last_week = {}

    # if simulating user picks, set up that data
    if simulate_picks
      user_seasons = SimUserSeason.all.map do |sim_user_season|
        [
          sim_user_season.id.to_s,
          {
            name: sim_user_season.sim_user.full_name,
            picks: [],
            total: 0,
          }
        ]
      end.to_h
    end

    # for each week,
    matchup_weeks.each do |week_number, games|
      # print a header
      puts
      puts "*"*100
      puts " WEEK #{week_number} (#{games.size} games)"
      puts "*"*100
      puts

      # store a copy of team data template
      this_week = team_data.deep_dup

      # special arithmetic for first week
      is_first_week = last_week.empty?

      # loop through the games
      games.each do |game|
        away_team = game.sim_matchup_teams.away_team
        home_team = game.sim_matchup_teams.home_team

        # FOR THE AWAY TEAM:
        away_team_last_week = last_week[away_team.team.id.to_s]

        #  - generate this week's data
        away_results = away_team_last_week.nil? ? [] : away_team_last_week[:results_after]
        away_results_for_strength = is_first_week ? mock_record : away_team_last_week[:results_after]
        weighted_record, weighted_last_3, weighted_home, weighted_random, away_strength = generate_strength(away_results_for_strength, false)

        #  - assemble data into a hash for printing
        away_team_this_week = {
          full_name: away_team.team.full_name,
          results_before: away_results,
          last3: away_results.compact.last(3).map{|r| r ? "W" : "L" }.join,
          results: away_results.compact.map{|r| r ? "W" : "L" }.join,
          weighted_record: weighted_record,
          weighted_last_3: weighted_last_3,
          weighted_home: weighted_home,
          weighted_random: weighted_random, 
          strength: away_strength,
          opponent_id: home_team.team.id.to_s,
          print: true,
        }

        # FOR THE HOME TEAM:
        home_team_last_week = last_week[home_team.team.id.to_s]

        #  - generate this week's data
        home_results = home_team_last_week.nil? ? [] : home_team_last_week[:results_after]
        home_results_for_strength = is_first_week ? mock_record : home_team_last_week[:results_after]
        weighted_record, weighted_last_3, weighted_home, weighted_random, home_strength = generate_strength(home_results_for_strength, true)

        #  - assemble data into a hash for printing
        home_team_this_week = {
          full_name: home_team.team.full_name,
          results_before: home_results,
          last3: home_results.compact.last(3).map{|r| r ? "W" : "L" }.join,
          results: home_results.compact.map{|r| r ? "W" : "L" }.join,
          weighted_record: weighted_record,
          weighted_last_3: weighted_last_3,
          weighted_home: weighted_home,
          weighted_random: weighted_random, 
          strength: home_strength,
          opponent_id: away_team.team.id.to_s,
          print: true,
        }

        # GENERATE ODDS BASED ON RECORDS
        away_odds = odds(away_strength, home_strength)
        home_odds = odds(home_strength, away_strength)
        away_team_this_week[:odds] = away_odds
        home_team_this_week[:odds] = home_odds

        # GENERATE A RESULT BASED ON THOSE ODDS
        underdog_odds = [away_odds, home_odds].sort.first
        underdog_won = rand < underdog_odds
        away_won = ((underdog_odds == away_odds) && underdog_won) || ((underdog_odds == home_odds) && !underdog_won)

        away_team_this_week[:won] = away_won
        home_team_this_week[:won] = !away_won
        away_team_this_week[:results_after] = away_team_this_week[:results_before].deep_dup << away_won
        home_team_this_week[:results_after] = home_team_this_week[:results_before].deep_dup << !away_won

        # STORE
        this_week[away_team.team.id.to_s] = away_team_this_week
        this_week[home_team.team.id.to_s] = home_team_this_week
      end

      # make sure we include teams with byes, for continuity
      bye_team_ids = this_week.reject{|id, data| data.present?}.keys
      bye_team_ids.each do |team_id|
        old_result_set = is_first_week ? [] : last_week[team_id][:results_after]
        new_result_set = old_result_set.deep_dup << nil
        this_week[team_id] = {
          results_before: old_result_set,
          results_after: new_result_set,
          print: false,
        }
      end

      # store w/o byes, for user pick options
      playing_this_week = this_week.keys - bye_team_ids

      #  - print results table
      tp this_week.values.map{|team| printable_team(team) }
      puts
      unless bye_team_ids.empty?
        # puts "#{this_week.keys.size - bye_team_ids.size} teams played"
        puts "bye: #{bye_team_ids.map{|bye_team_id| Team.find(bye_team_id).abbr }.join(", ")}"
        puts
      end

      #  - store
      last_week = this_week

      # simulate user picks retroactively
      if simulate_picks
        # print a header
        puts
        puts "~~~~~~~~~~~~~~~~~~~~~"
        puts " User picks"
        puts "~~~~~~~~~~~~~~~~~~~~~"
        puts

        # loop through users
        user_seasons.each do |user_season_id, user_data|
          # available teams are the ones playing this week minus the ones they've already chosen
          options = playing_this_week - user_data[:picks]

          # pick a team at random
          pick_team_id = options.sample

          # how'd they do?
          pick = this_week[pick_team_id]
          opponent = this_week[pick[:opponent_id]]
          pts = points(pick, opponent)

          # store data
          new_data = user_data.deep_dup
          new_data[:picks] << pick_team_id
          new_data[:picked] = pick[:full_name]
          new_data[:change] = display_pts(pts)
          new_data[:total] = user_data[:total] + pts
          new_data[:points] = display_pts(new_data[:total])
          user_seasons[user_season_id] = new_data
        end

        # print picks table
        tp user_seasons.values.sort_by{|user_season| 0 - user_season[:total] }.map{|user_season| printable_pick(user_season) }
        3.times do; puts; end

      end
    end
  end
end
