class SiteController < ApplicationController
  skip_before_action :check_banned

  def index
    @groups = Group.all
  end
end
