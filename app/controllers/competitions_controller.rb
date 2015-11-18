class CompetitionsController < ApplicationController
  def show
    @competition = Competition.find(params[:id])

    # This is not the actual pot total
    # Need a table tracking received payments
    @pot_total = @competition.buyin * @competition.group.users.count

  end

  def pick
  end
end
