class Matchup < ApplicationRecord
  belongs_to :week
  has_many :matchup_teams, dependent: :destroy
end
