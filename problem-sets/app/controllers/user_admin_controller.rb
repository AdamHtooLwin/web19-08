class UserAdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.all
  end

  def ban_user
    user = User.find(params[:user_id])
    user.ban

    redirect_to user_admin_index_path
  end

  private
  def check_admin
    if !current_user or !current_user.is_admin
      redirect_to site_index_path
    end
  end
end
