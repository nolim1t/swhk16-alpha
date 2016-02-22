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

  # Show user list
  def userlist
    if current_user.accounttype == "admin" then
      userlist = User.all
      @userlist = []
      userlist.each {|user|
        verified = "no"
        if user[:identity_verified] == 1 then
          verified = "yes"
        end
        @userlist << {:name => user[:name], :email => user[:email], :accounttype => user[:accounttype], :identity_verified => verified, :cards => Card.where(owner_id: user[:_id].to_s)}
      }
    else
      redirect_to "/"
    end
  end

  # Show transfer list
  def transferlist
    if current_user.accounttype == "admin" then
      transferlist = Transfer.all
      @transferlist = []
      transferlist.each {|transfer|
        @transferlist << {:id => transfer[:_id], :asset_id => transfer[:asset_id], :asset_desc => Card.find(transfer[:asset_id]), :sender => User.where(:email => transfer[:sender_email]), :receiver => User.where(:email => transfer[:receiver_email])}
      }
    else
      redirect_to "/"
    end
  end
end