class RegistrationsController < DeviseController
  def new
    super
  end

  def create
    user = User.create(user_params)
    session[:user_id] = user.id
    redirect_to root_path
  end

  def update
    super
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :avatar)
  end

end
