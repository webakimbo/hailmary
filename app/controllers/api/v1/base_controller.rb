class Api::V1::BaseController < ApplicationController
  before_action :verify_api_access
  before_action :validate_user_season

private

  def validate_user_season
    # redirect_to root_path unless @current_user_season.present?
  end

  def verify_api_access
    # unless current_user.can?(:view, AppFeature.api)
    #   render text: "Not allowed", status: :unauthorized and return
    # end
  end

end
