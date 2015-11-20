require 'hailmary/oddsapi'

class ApplicationController < ActionController::Base
  include OddsApi

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :get_current_user
  before_filter :open_api

  private

  def get_current_user
    @user = User.find(1)
  end

  def open_api
    @data = JsonOdds.new
  end

end
