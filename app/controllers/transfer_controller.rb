class TransferController < ActionController::Base
  before_action :authenticate_user!
  layout 'application'

  def outbound
    if params[:transfer] then
      begin
        card = Card.find(params[:transfer][:cardid])
      rescue
        card = nil
      end
      if card[:cardname] then
        if card[:cardname].downcase == params[:transfer][:cardname].downcase then
          if card[:transfer_status] != 1 then
            if params[:transfer][:agree] == "1" then
              transfer_info_msg = TransferHelper::Outgoing.send(current_user.email, params[:transfer][:email].to_s, params[:transfer][:cardid].to_s, "card")
              if transfer_info_msg[:error] != ""
                flash[:error] = transfer_info_msg[:error]
                self.goback
              else
                puts "Transfer request: Card ID=#{params[:transfer][:cardid]} / Name of card: #{params[:transfer][:cardname]}/ To: #{params[:transfer][:email]} / Agreed: #{params[:transfer][:agree]}"
                @transfer_id = transfer_info_msg[:info]
              end
            else
              flash[:error] = "You must accept the terms before you can transfer this card"
              self.goback
            end
          else
            flash[:error] = "Card is currently being transferred"
            self.goback
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

  def rejecttransfer
    puts "Processing transfer id #{params[:id]}"
    transfer_reject_status = TransferHelper::Outgoing.reject(params[:id])
    puts transfer_reject_status.inspect
    # Maybe handle the error message
    # Redirect to cards
    redirect_to "/"
  end

  def acceptransfer
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
