class Season < ApplicationRecord
  include Simulation

  has_many :weeks

  def current_week
    if sim_mode?
      # SimMatchup.where('final = ?', false)&.first&.week || SimMatchup.last.week
      SimMatchup.where('final = ?', false)&.first&.week
    else
      # weeks.where.not('start > ?', DateTime.now)&.last || weeks.last
      weeks.where.not('start > ?', DateTime.now)&.last
    end
  end

  def complete?
    if sim_mode?
      SimMatchup.pluck(:final).all?
    else
      Matchup.where(week_id: weeks.map(&:id)).pluck(:final).all?
    end
  end

  def self.current_season
    new.sim_mode? ? SimMatchup.first&.week&.season : Season.last
  end

  def self.advance_week
    # simulation mode only
    return unless new.sim_mode?

    # find the first unfinished week, unless season is complete
    this_week = new.current_week
    if this_week.present?
      # log results
      this_week.log_results

      # run odds for next week's matchups
      # since the simulation just closed out last week, `current_week` will pull next week now
      new_week = new.current_week
      if new_week.present?
        games = SimMatchup.where('week_id = ?', new_week.week)
        calculate_odds(games)
      end
    end
  end

  def self.reset
    # simulation mode only
    return unless new.sim_mode?

    # remove all picks
    SimPick.destroy_all

    # set all matchups to unfinished
    SimMatchup.update_all(final: false)

    # set all matchup teams to original seeded state
    SimMatchupTeam.update_all(odds: 0.500, score: 0, won: false)

    # reset all user points
    SimUserSeason.update_all(points: 0)

    # run odds for first week's matchups
    games = SimMatchup.where(week_id: 1)
    calculate_odds(games)
  end

  def self.calculate_odds(games)
    games.each do |game|
      away_team = game.sim_matchup_teams.away_team
      home_team = game.sim_matchup_teams.home_team

      *away_ignore, away_strength = new.generate_strength(away_team.team.current_season_results, false)
      *home_ignore, home_strength = new.generate_strength(home_team.team.current_season_results, true)

      away_odds = new.generate_odds(away_strength, home_strength)
      home_odds = new.generate_odds(home_strength, away_strength)

      away_team.update(odds: away_odds)
      home_team.update(odds: home_odds)
    end
  end

  private_class_method :calculate_odds

end
