class CardverifyController < ApplicationController
  def index
		if current_user.accounttype == "vendor" then
      @cardlist = []      
      if params[:cardverify] != nil then
        if params[:cardverify][:email] != nil then
          check_cards = Validationqueue.where(:requestor_email_address => params[:cardverify][:email])
          if check_cards.count > 0 then
            check_cards.each {|pc|
              rc = Card.find(pc.card_id)
              @cardlist << {:cardname => rc.cardname, :_id => rc._id}
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
end
