class Week < ApplicationRecord
  include Simulation

  belongs_to :season

  def is_last?
    self == season.weeks.last
  end

  def picks_complete?
    # we only care about picks made by humans;
    # picks for fake users will be made in sim mode in Season.advance_week
    pick_model.where(week: self).size == UserSeason.where(season: season).size
  end

  def log_results
    # store results
    if sim_mode?
      generate_results(self)
    else
      # TODO: how to get actual (unsimulated) NFL results in the db, and update the matchup records?
    end

    # update season totals
    user_season_model = sim_mode? ? SimUserSeason : UserSeason
    pick_model_for_join = sim_mode? ? :sim_picks : :picks
    user_season_model.includes(pick_model_for_join.to_sym).where(season: season).each do |user_season|
      total = user_season.points
      pick = user_season.picks.where(week: self).first
      total += pick.present? ? pick.points : Constants::NO_PICK_PENALTY
      user_season.update(points: total)
    end
  end

private

  def pick_model
    sim_mode? ? SimPick : Pick
  end

end
