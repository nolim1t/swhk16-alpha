class TransferController < ActionController::Base
  before_action :authenticate_user!
  layout 'application'

  def outbound_card
    recepient_email =  transfer_params[:receiver_email]
    card = Card.find(transfer_params[:cardid])
# raise User.where(receiver_email: recepient_email).present?.inspect
    if User.where(receiver_email: recepient_email).present?

      if card[:transfer_status] != 1
        if transfer_params[:agree] == "1" then
          transfer_info_msg = TransferHelper::Outgoing.send(current_user.email, transfer_params[:receiver_email].to_s, transfer_params[:cardid].to_s, "card")
          if transfer_info_msg[:error] != ""
            flash[:error] = transfer_info_msg[:error]
            self.goback
          else
            puts "Transfer request: Card ID=#{params[:transfer][:cardid]} / Name of card: #{params[:transfer][:cardname]}/ To: #{params[:transfer][:email]} / Agreed: #{params[:transfer][:agree]}"
            @transfer_id = transfer_info_msg[:info]
            respond_to do |format|
              format.html { redirect_to testing_display_path, notice: "Your card will be transferred" }
              format.js { @success = true } 
            end
          end
        else
          respond_to do |format|
            format.html { redirect_to testing_display_path, notice: "Your card will be transferred"}
            format.js { @success = false }
          end
          # flash[:error] = "You must accept the terms before you can transfer this card"
        end
      else
        respond_to do |format|
          format.html { redirect_to testing_display_path, notice: "Your card will be transferred" }
          format.js { @success = false }
        end
      # flash[:error] = "Card is currently being transferred"
      end
    else
      respond_to do |format|
        format.html { redirect_to testing_display_path }
        format.js { @success = false }
      end
      flash[:error] = "Sorry We can't find this user in our database, do you want us to send him an invitation email? ... (to be refined)" 
    end
  end

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
    puts "Processing transfer id #{params[:id]}"
    transfer_accept_status = TransferHelper::Incoming.accept(current_user._id.to_s, params[:id])
    redirect_to "/"
  end

  def inbound
    @list = Transfer.where(receiver_email: current_user.email)
  end

  # Helpers
  def goback
    if request.referer then
      redirect_to request.referer
    else
      redirect_to "/"
    end
  end

private
  def transfer_params
    params.require(:transfer).permit!
  end

end
