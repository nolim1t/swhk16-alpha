class CardverifyController < ApplicationController
  before_action :authenticate_user!

  def index
		if current_user.accounttype == "vendor" then
      @cardlist = []
      if params[:cardverify] != nil then
        if params[:cardverify][:email] != nil then
          check_cards = Validationqueue.where(:requestor_email_address => params[:cardverify][:email])
          if check_cards.count > 0 then
            check_cards.each {|pc|
              rc = Card.find(pc.card_id)
              if rc.transfer_status == 0 then
                @cardlist << {:cardname => rc.cardname, :_id => rc._id}                
              end
            }
          end
        end
      end
      render :template => "cardverify/index"
		else
			# Access denied
			redirect_to "/"
		end
	end

  def menu
    if current_user.accounttype == "vendor" then
      render :template => "cardverify/menu"
    else
      redirect_to "/"
    end
  end

  def rejectcard
    if current_user.accounttype == "vendor" then
      self.reject_or_approve("reject", params[:id])
      self.redirection
    else
      redirect_to "/"
    end
  end

  def acceptcard
    if current_user.accounttype == "vendor" then
      self.reject_or_approve("approve", params[:id])
      self.redirection
    else
      redirect_to "/"
    end
  end

  # Helper functions
  def redirection
    if request.referer != nil then
      redirect_to request.referer
    else
      redirect_to '/vendor'
    end
  end

  def reject_or_approve(type, id)
    verb = "rejected"
    card_new_status = 0
    if type == "approve" then
      verb = "approved"
      card_new_status = 2
    end

    validation_queue = Validationqueue.where(:card_id => id)
    if validation_queue.length > 0 then
      card = Card.find(id)
      Cardnote.create(
        text: "Shopkeeper #{verb} card",
        create_date: Time.new(),
        card_id: id.to_s
      )
      validation_queue.delete
      card.update_attributes(validation_status: card_new_status)
    end
  end
end
