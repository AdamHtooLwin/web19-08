class ProfileController < ApplicationController
  before_action :set_user, only: [:update_avatar, :update]
  def show

  end

  def edit
  end

  def update
    user_params
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.email = params[:email]
    @user.save
    redirect_to profile_show_path
  end

  def update_avatar
    user_params
    @user.avatar = params[:avatar]
    redirect_to profile_show_path
      #
      # respond_to do |format|
      #   if @profile.update_avatar(user_params)
      #     format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
      #     format.json { render :show, status: :ok, location: @profile }
      #   else
      #     format.html { render :edit }
      #     format.json { render json: @profile.errors, status: :unprocessable_entity }
      #   end
      # end
    end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
        params.permit(:first_name, :last_name, :email, :password, :avatar)
    end

  end
