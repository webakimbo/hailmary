class WeeksController < ApplicationController

  def show
    load_leaderboard_data
  end

end
