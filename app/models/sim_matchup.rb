class SimMatchup < ApplicationRecord
  belongs_to :week
  has_many :sim_matchup_teams

  alias_attribute :matchup_teams, :sim_matchup_teams
end
