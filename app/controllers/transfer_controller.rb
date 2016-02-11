class TransferController < ActionController::Base
  before_action :authenticate_user!
  def outbound
    if params[:transfer] then
      card = Card.find(params[:transfer][:cardid])
      puts "#{card[:cardname]}"
      if card[:cardname].downcase == params[:transfer][:cardname].downcase then
        if params[:transfer][:agree] == "1" then
          puts "Transfer request: Card ID=#{params[:transfer][:cardid]} / Name of card: #{params[:transfer][:cardname]}/ To: #{params[:transfer][:email]} / Agreed: #{params[:transfer][:agree]}"
        else
          puts "User didn't accept agreement"
        end
      else
        puts "User didn't type the name of the card in correctly"
      end
    else
      puts "Invalid parameters"
    end
  end

  def inbound
  end
end
