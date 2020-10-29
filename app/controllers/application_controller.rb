class ApplicationController < ActionController::Base
  before_action :gon_params

  def gon_params
    gon.params = params.permit(:id)
    gon.user = current_user&.id
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, flash: exception.message
  end

  check_authorization unless: :devise_controller?

end
