class Api::V1::BaseController < ActionController::Base
  before_action :doorkeeper_authorize!
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :forbidden }
    end
  end

  private

  def current_ability
    @current_ability ||= Ability.new(current_resource_owner)
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

end
