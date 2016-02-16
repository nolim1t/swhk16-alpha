class AdminpageController < ApplicationController
  before_action :authenticate_user!
  # Index page
  def index
    if current_user.accounttype == "admin" then
      render :template => "adminpage/menu"
    else
      redirect_to "/"
    end
  end
end
