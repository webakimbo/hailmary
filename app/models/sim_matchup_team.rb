class SimMatchupTeam < ApplicationRecord
  include Simulation

  belongs_to :sim_matchup
  belongs_to :team

  alias_attribute :matchup, :sim_matchup

  scope :away_team, -> { where('home = ?', false)&.first }
  scope :home_team, -> { where('home = ?', true)&.first }

  def opponent
    sim_matchup.sim_matchup_teams.where(home: !home)&.first
  end

  def outcomes
    possible_outcomes(odds, opponent.odds)
  end

  def display_outcomes
    outcomes.map{|outcome| display_pts(outcome) }
  end

end
