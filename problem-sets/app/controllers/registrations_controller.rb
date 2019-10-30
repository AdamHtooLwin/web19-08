class RegistrationsController < ApplicationController
  def new
    super
  end

  def create
    user = User.create(user_params)
    session[:user_id] = user.id
    redirect_to root_path  end
  def update
    super
  end
end
