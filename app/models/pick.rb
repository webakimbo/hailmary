class Pick < ApplicationRecord
  include Simulation

  belongs_to :user_season
  belongs_to :week
  belongs_to :matchup_team

  def display_outcomes
    outcomes = possible_outcomes(odds, (1 - odds))
    outcomes.map{|outcome| display_pts(outcome) }
  end

end
