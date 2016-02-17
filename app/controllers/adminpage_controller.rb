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

  # Generate invite code
  def generateinvite
    if current_user.accounttype == "admin" then
      if params[:generateinvite] then
        if params[:generateinvite][:invitecode] == "yes" then
          @invitecode = Invitecode.create["code"]
        end
      end
    else
      redirect_to "/"
    end
  end
end
