class CompetitionsController < ApplicationController
  before_filter :setup_competition

  def show
  end

  def pick
    @odds = JSON.parse @data.odds
    @teams = Team.all

    # We'll want to disable the interactivity of this page if the pick deadline has passed
  end

  private

  def setup_competition
    @competition = Competition.find(params[:id])

    # This is not the actual pot total
    # Need a table tracking received payments
    @pot_total = @competition.buyin * @competition.group.users.count
  end

end
