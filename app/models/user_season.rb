class UserSeason < ApplicationRecord
  include UserSeasons

  belongs_to :user
  belongs_to :season
  has_many :picks, dependent: :destroy

  # def already_picked(week_id)
  #   picks.where(week_id: week_id).pluck(:team_id)
  # end

  # def pick_options(week_id)
  #   already_picked = picks.where(week_id: week_id).pluck(:team_id)
  #   playing_this_week = MatchupTeam.joins(:matchup)
  #                                  .where('matchups.week_id = ?', week_id)
  #                                  .pluck(:team_id)
  # end

end
