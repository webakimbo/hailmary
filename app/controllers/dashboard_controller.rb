class DashboardController < ApplicationController
  def index

    season = Season.where(current: true).first
    @competitions = Competition.where(season_id: season.id, group_id: @user.groups.map{ |group| group.id })

  end
end
