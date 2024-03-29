require 'csv'

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
      @adminpage = User.all.paginate(:page => params[:page], :per_page => 20)
      @userlist = []
      @export_CSV = "name,email,accounttype,verified,cards,deleted\n"
      @adminpage.each {|user|
        verified = "no"
        if user[:identity_verified] == 1 then
          verified = "yes"
        end
        to_insert = {:id => user[:_id], :name => user[:name], :email => user[:email], :accounttype => user[:accounttype], :identity_verified => verified, :cards => Card.where(owner_id: user[:_id].to_s, :transfer_status => 0, :deleted_status => 0), :deleted_cards => Card.where(owner_id: user[:_id].to_s, :transfer_status => 0, :deleted_status => 1)}
        if params[:page]
          @page = params[:page]
        else
          @page = 1
        end
        @userlist << to_insert
        @export_CSV << "\"#{to_insert[:name]}\",\"#{to_insert[:email]}\",\"#{to_insert[:accounttype]}\",\"#{to_insert[:identity_verified]}\",\"#{to_insert[:cards].count}\",\"#{to_insert[:deleted_cards].count}\"\n"
      }
      respond_to do |format|
        format.html
        format.csv {send_data @export_CSV}
      end
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
        @transferlist << {:id => transfer[:_id], :asset_id => transfer[:asset_id], :asset_desc => Card.find(transfer[:asset_id]), :sender_email => transfer[:sender_email], :sender => User.where(:email => transfer[:sender_email]), :receiver_email => transfer[:receiver_email], :receiver => User.where(:email => transfer[:receiver_email])}
      }
    else
      redirect_to "/"
    end
  end

  # Def show user cards (basically a page which shows the type of cards)
  def usercards
    if current_user.accounttype == "admin" then
      @cards = Card.where(:owner_id => params[:id], :transfer_status => 0, :deleted_status => 0).order_by([:create_date, :desc]).paginate(:page => params[:page], :per_page => 6)
      @cardimages = []
      @cards.each{|card|
        cardimages_result = Cardimage.where(:card_id => card._id.to_s, :image_type => "front").order_by([:create_date, :desc]).limit(2)
        cardimages_result.each{|cardimage_result|
  				@cardimages << cardimage_result
  			}
        @cards_and_images = @cards.zip(@cardimages).map{|c,i| [c,i]}
      }
      @pagetitle = "User cards"
      @pagedescription = "List of all cards for this user"
    else
      redirect_to "/"
    end
  end

  def graveyard
    if current_user.accounttype == "admin" then
      @cards = Card.where(:transfer_status => 0, :deleted_status => 1).order_by([:create_date, :desc]).paginate(:page => params[:page], :per_page => 6)
      @cardimages = []
      @cards.each{|card|
        cardimages_result = Cardimage.where(:card_id => card._id.to_s, :image_type => "front").order_by([:create_date, :desc]).limit(2)
        cardimages_result.each{|cardimage_result|
  				@cardimages << cardimage_result
  			}
        @cards_and_images = @cards.zip(@cardimages).map{|c,i| [c,i]}
      }
      @pagetitle = "The Graveyard 👻💀"
      @pagedescription = "List of all deleted cards in the graveyard (deleted cards)"
      render "adminpage/usercards"
    else
      redirect_to "/"
    end
	end
end
