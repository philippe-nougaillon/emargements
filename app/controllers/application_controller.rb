class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :detect_device_format
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :prepare_exception_notifier

  private

  def detect_device_format
    case request.user_agent
    when /iPhone/i, /Android/i && /mobile/i, /Windows Phone/i
      request.variant = :phone
    else
      request.variant = :desktop
    end
  end

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_index_path : super
  end

  def user_not_authorized
    flash[:alert] = "Vous n'êtes pas autorisé à effectuer cette action."
    redirect_back(fallback_location: root_path)
  end

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user
    }
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:nom, :prénom, :email, :adresse, :password, :password_confirmation)}
    end
end
