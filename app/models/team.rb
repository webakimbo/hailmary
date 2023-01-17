class Team < ApplicationRecord

  def full_name
    [city, name].join(" ")
  end

  def current_season_all_games
    if sim_mode?
      SimMatchupTeam.joins(sim_matchup: { week: :season })
                    .where('team_id = ?', id)
                    .where('seasons.id = ?', current_season.id)
                    .order('sim_matchups.kickoff')
    else
      MatchupTeam.joins(matchup: { week: :season })
                 .where('team_id = ?', id)
                 .where('seasons.id = ?', current_season.id)
                 .order('matchups.kickoff')
    end
  end

  def current_season_played_games
    current_season_all_games.where('sim_matchups.final = ?', true)
  end

  def current_season_results
    current_season_played_games.map{|game| game.won }
  end

  def last_3_results
    current_season_results.last(3)
  end

  def current_season_record
    current_season_results.partition{|result| result }
                          .map{|results| results.size }
                          .join("-")
  end

private

  def current_season
    Season.current_season
  end

end
