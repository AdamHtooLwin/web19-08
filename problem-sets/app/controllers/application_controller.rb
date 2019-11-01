class ApplicationController < ActionController::Base
  before_action :check_banned, except:

  def check_banned
    if user_signed_in?
      if current_user.is_banned and request.path != '/users/sign_out'
        redirect_to site_index_path
      end
    end
  end
end
