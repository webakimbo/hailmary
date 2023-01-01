class ApplicationController < ActionController::Base
  before_action :load_season
  include EnvVars

protected

  def load_season
    @season = sim_mode? ? SimMatchup.first&.week&.season : Season.last
  end

end
