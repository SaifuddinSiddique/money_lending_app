class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_loans_path
    else
      user_dashboard_path
    end
  end

  def authenticate_admin!
    unless current_user&.role == "admin"
      redirect_to root_path, alert: "Access denied."
    end
  end

  protected

  def configure_permitted_parameters
    # For sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])

    # For account update (optional, if users can update their name)
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])

    # For sign in, Devise typically uses only email and password, adding :name is unusual
    # But if you really want to permit it:
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :name ])
  end
end
