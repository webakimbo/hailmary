class SimMatchupTeam < ApplicationRecord
  belongs_to :sim_matchup
  belongs_to :team

  alias_attribute :matchup, :sim_matchup

  scope :away_team, -> { where('home = ?', false)&.first }
  scope :home_team, -> { where('home = ?', true)&.first }
end
