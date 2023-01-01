class WeeksController < ApplicationController
  before_action :load_current_week

  def show
    if sim_mode?
      @user_seasons = SimUserSeason.where(season: @season).order(points: :desc)
      @matchups = SimMatchup.where(week: @week).order(:kickoff)
    else
      @user_seasons = UserSeason.where(season: @season).order(points: :desc)
      @matchups = Matchup.where(week: @week).order(:kickoff)
    end
  end

private

  def load_current_week
    # @week = sim_mode? ? Week.find(SimMatchup.current_week.to_i) : (@season.weeks.where.not('start > ?', DateTime.now)&.last || @season.weeks.last)
    # @week = @season.current_week(sim_mode?)
    @week = @season.current_week
  end

end
