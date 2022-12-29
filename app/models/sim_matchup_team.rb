class SimMatchupTeam < ApplicationRecord
  belongs_to :sim_matchup
  belongs_to :team

  scope :away_team, -> { where('home = ?', false)&.first }
  scope :home_team, -> { where('home = ?', true)&.first }
end
