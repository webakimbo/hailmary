class DashboardController < ApplicationController
  def index

    current_season = Season.where(current: true).first rescue nil
    past_seasons = Season.where(current: false)

    @competitions = current_season.nil? ? [] : Competition.where(season_id: current_season.id, group_id: @user.groups.map{ |group| group.id })
    @past_competitions = Competition.where(season_id: past_seasons.map{ |season| season.id }, group_id: @user.groups.map{ |group| group.id })

  end
end
