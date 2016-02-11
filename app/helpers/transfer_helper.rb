module TransferHelper
  class Outgoing
    def self.send(from, to, assetid, assettype)
      result = {:info => "", :error => ""}
      if assettype == "card" then
        recipient = User.where(email: to)
        sender = User.where(email: from)
        puts "Sender: #{sender[0].inspect}"
        if recipient.count == 1 then
          puts "Recipient: #{recipient[0][:email]}"
          begin
            card = Card.find(assetid)
          rescue
            card = nil
          end
          if card != nil
            puts "Card=#{card.inspect} Sender=#{sender[0]}"
            if card.owner_id.to_s == sender[0][:_id].to_s then
              transfer = Transfer.create(asset_id: assetid, asset_type: assettype, sender_email: from, receiver_email: to, arbiter_email: "info@vaultron.co", create_date: Time.now())
              # Create a note
              Cardnote.create(
              	text: "Transfer of card to #{to} has been started",
              	create_date: Time.new(),
              	card_id: assetid.to_s
              )
              # Set transfer to bending
              card.update_attributes(transfer_status: 1, owner_id: recipient[0][:_id])
              result[:info] = "#{transfer._id.to_s}"
              result
            else
              result[:error] = "Card is no longer owned by you"
              result
            end
          else
            result[:error] = "Card doesn't exist"
            result
          end
        else
          result[:error] = "The user you tried to transfer to doesn't exist. But don't worry, very soon they will get an invite code and you won't see this message"
          result
        end
      else
        result[:error] = "Invalid asset type"
        result
      end
    end

    def self.reject(transfer_id)
      result = {:info => "", :error => ""}
      begin
        transfer = Transfer.find(transfer_id)
      rescue
        transfer = nil
      end
      if transfer != nil
        sender = User.where(email: transfer.sender_email)
        puts "Transfer: #{transfer.inspect}"
        begin
          card = Card.find(transfer.asset_id)
        rescue
          card = nil
        end
        if card != nil then
          if sender.count == 1 then
            card.update_attributes(transfer_status: 0, owner_id: sender[0][:_id].to_s)
            # Create a note
            Cardnote.create(
              text: "Transfer of card has been rejected",
              create_date: Time.new(),
              card_id: transfer.asset_id.to_s
            )
            result[:info] = "Transfer has been rejected"
            result
          else
            result[:error] = "Can't find transfer"
            result
          end
        else
          result[:error] = "Can't find card to update"
          result
        end
      else
        result[:error] = "Invalid transfer to reject"
        result
      end
    end
  end
end
