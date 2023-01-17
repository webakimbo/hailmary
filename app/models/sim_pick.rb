class SimPick < ApplicationRecord
  include Simulation

  belongs_to :sim_user_season
  belongs_to :week
  belongs_to :sim_matchup_team

  alias_attribute :user_season, :sim_user_season
  alias_attribute :matchup_team, :sim_matchup_team

  # # Sends <turbo-stream action="replace" target="clearance_5"><template><div id="clearance_5">My Clearance</div></template></turbo-stream>
  # # to the stream named "identity:2:clearances"
  # clearance.broadcast_replace_to examiner.identity, :clearances

  # after_create_commit -> { broadcast_prepend_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: "quotes" }
  after_create_commit -> { broadcast_replace_to "ws:leaderboard", 
                                                partial: "weeks/leaderboard_name", 
                                                locals: { user_season: sim_user_season, week: week }, 
                                                target: "user_season_name_#{sim_user_season.id}"
                          }

  def display_outcomes
    outcomes = possible_outcomes(odds, (1 - odds))
    outcomes.map{|outcome| display_pts(outcome) }
  end

end
