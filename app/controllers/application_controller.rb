class ApplicationController < ActionController::Base
  before_action :make_action_mailer_use_request_host_and_protocol
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_current_season_data

  include EnvVars

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :contact_preference])
  end

  def load_current_season_data
    user_season_model = sim_mode? ? SimUserSeason : UserSeason
    matchup_model = sim_mode? ? SimMatchup : Matchup

    # current season
    @season = Season.current_season

    # current_user's season to date
    @current_user_season = user_season_model.where(season: @season, user: current_user)&.first
    @already_picked_ids = @current_user_season&.already_picked_ids || []

    # get info about this week: week, matchups, current_user's pick
    # or if the season is over, some placeholder nils
    @week = @season.current_week
    if @season.complete?
      @matchups = nil
      @pick = nil
    else
      @matchups = matchup_model.where(week: @week).order(:kickoff)
      @pick = @current_user_season&.pick(@week.id)
    end
  end

  def load_leaderboard_data
    user_season_model = sim_mode? ? SimUserSeason : UserSeason
    pick_model_for_join = sim_mode? ? :sim_picks : :picks
    @user_seasons = user_season_model.includes(pick_model_for_join.to_sym)
                                     .where(season: @season)
                                     .order(points: :desc)
  end

private

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

end
