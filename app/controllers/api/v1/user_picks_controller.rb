class Api::V1::UserPicksController < Api::V1::BaseController
  before_action :load_models

  def make_pick
    # find the user's season
    # user_season = @user_season_model.find(user_picks_params[:user_season_id])

    # find (or create) the pick record
    # pick = user_season.picks.find_or_create_by(user_season: user_season, week_id: user_picks_params[:week_id])
    pick = @current_user_season.picks.find_by(week_id: user_picks_params[:week_id])
    @previous_pick = pick.deep_dup
    if pick.nil?
      pick = @current_user_season.picks.create(week_id: user_picks_params[:week_id])
    end

    # re-pull the odds, since 1) it's not safe to pass that from the client, and 2) they could be stale
    matchup_team = @matchup_team_model.find_by_id(user_picks_params[:matchup_team_id])

    # update values
    pick.assign_attributes(matchup_team: matchup_team, odds: matchup_team.odds)

    # puts "******* already picked, before save *******"
    # puts @current_user_season.already_picked_ids || []
    # puts "*******************************************"

    if pick.save!
      # head :ok
      @current_user_season.reload
      @already_picked_ids = @current_user_season.already_picked_ids || []
      @pick = pick

      # puts "******* already picked, after save *******"
      # puts @already_picked_ids.inspect
      # puts "******************************************"

      # render partial: "weeks/my_week_matchups"
      respond_to do |format|
        format.turbo_stream
        # format.html { redirect_to pick_path, notice: "Yay." }
      end

    else
      # format.html { render :new, status: :unprocessable_entity }
      render inline: pick.errors.full_messages.first, status: :not_acceptable
    end
  end

private

  def load_models
    @user_season_model = sim_mode? ? SimUserSeason : UserSeason
    @matchup_team_model = sim_mode? ? SimMatchupTeam : MatchupTeam
  end

  def user_picks_params
    params.permit(:user_season_id, :week_id, :matchup_team_id, :odds)
  end

end
