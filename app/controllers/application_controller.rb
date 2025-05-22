class ApplicationController < ActionController::Base
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
end
