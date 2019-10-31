class UserAdminController < ApplicationController
  def index
    if !current_user or !current_user.is_admin
      redirect_to site_index_path
    end

    @users = User.all
  end
end
