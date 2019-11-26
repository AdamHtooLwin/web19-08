class SiteController < ApplicationController
  skip_before_action :check_banned

  def index
    if user_signed_in?
      @groups = current_user.groups
    end

  end
end
