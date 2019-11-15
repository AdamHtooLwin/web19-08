class ApplicationController < ActionController::Base
  before_action :check_banned
  before_action :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password])
  end

  def check_banned
    if user_signed_in?
      if current_user.is_banned and request.path != '/users/sign_out'
        redirect_to site_index_path
      end
    end
  end

  def check_admin
    if !current_user.is_admin
      redirect_to root_path
    end
  end
end
