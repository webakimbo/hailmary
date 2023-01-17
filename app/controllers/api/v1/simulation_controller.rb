class Api::V1::SimulationController < Api::V1::BaseController

  def advance_week
    Season.advance_week
    load_current_season_data
    load_leaderboard_data

    # render partial: "weeks/my_week_matchups"
    # format.turbo_stream do
    #   render turbo_stream: turbo_stream.append(:messages, partial: "messages/message",
    #     locals: { message: message })
    # end
    # format.html { redirect_to messages_url }

    respond_to do |format|
      format.turbo_stream
      # format.html { redirect_to pick_path, notice: "Yay." }
    end

  end

  def reset_simulation
    Season.reset
    load_current_season_data
    load_leaderboard_data

    # render partial: "weeks/my_week_matchups"
    
    respond_to do |format|
      format.turbo_stream
      # format.html { redirect_to pick_path, notice: "Yay." }
    end

  end

end
