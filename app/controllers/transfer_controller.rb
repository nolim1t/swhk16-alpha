class TransferController < ActionController::Base
  before_action :authenticate_user!
  def outbound
    if params[:transfer] then
      card = Card.find(params[:transfer][:cardid])
      if card[:cardname] then
        if card[:cardname].downcase == params[:transfer][:cardname].downcase then
          if card[:transfer_status] != 1 then
            if params[:transfer][:agree] == "1" then
              puts "Transfer request: Card ID=#{params[:transfer][:cardid]} / Name of card: #{params[:transfer][:cardname]}/ To: #{params[:transfer][:email]} / Agreed: #{params[:transfer][:agree]}"
              # TODO: Set up another ruby helper to facilitate this transfer
            else
              flash[:error] = "You must accept the terms before you can transfer this card"
              self.goback
            end
          else
            flash[:error] = "Card is currently being transferred"
          end
        else
          flash[:error] = "You must type in the name of the card before you can transfer it"
          self.goback
        end
      else
        flash[:error] = "Unable to locate the card that you were trying to transfer"
        self.goback
      end
    else
      puts "Invalid parameters"
    end
  end

  def inbound
  end

  # Helpers
  def goback
    if request.referer then
      redirect_to request.referer
    else
      redirect_to "/"
    end
  end
end
