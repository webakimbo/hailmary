class MatchupTeam < ApplicationRecord
  belongs_to :matchup
  belongs_to :team

  scope :away_team, -> { where('home = ?', false)&.first }
  scope :home_team, -> { where('home = ?', true)&.first }
end
