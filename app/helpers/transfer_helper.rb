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
          # Move the card to info@vaultron.co as custodian
          custodian_account = User.where(email: "info@vaultron.co")
          begin
            card = Card.find(assetid)
          rescue
            card = nil
          end
          if card != nil
            if card.owner_id.to_s == sender[0][:_id].to_s then
              transfer = Transfer.create(asset_id: assetid, asset_type: assettype, sender_email: from, receiver_email: to, arbiter_email: "info@vaultron.co", create_date: Time.now())
              # Assign to info@vaultron.co
              card.update_attributes(transfer_status: 1, owner_id: custodian_account[0][:_id])
              invitecode_result = Invitecode.create(postprocess_instructions: "email", email: to)
              Emailbot.send("info@vaultron.co", to, "You have been sent some cards", "Hi!\n\nYou have some cards on Vaultarch that is waiting for you.\n\nTo claim these cards, please sign up at https://vaultarch.com/register using the email address #{to} (don't worry, you can change this later) and use the invite code: #{invitecode_result.code} (or any previous codes you were sent which should also work)\n\nWhy Vaultron?\n\nVaultron is a platform for securing the value of your collectibles. While we can't prevent past forgeries, we can put a stop for future forgeries. We're currently in closed beta now.")
              result[:info] = "#{transfer._id.to_s}"
              result
            else
              result[:error] = "Card isn't owned by you"
              result
            end
          else
            result[:error] = "Unable to find card to transfer"
            result
          end
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
            transfer.destroy
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

  class Incoming
    def self.accept(current_userid, transfer_id)
      result = {:info => "", :error => "", :asset => ""}
      begin
        transfer = Transfer.find(transfer_id)
      rescue
        transfer = nil
      end
      if transfer != nil then
        begin
          card = Card.find(transfer.asset_id)
        rescue
          card = nil
        end
        if card != nil then
          if (card.owner_id == current_userid) then
            # Make sure that only the new owner can accept
            # then take possession of the card
            transfer.destroy
            card.update_attributes(transfer_status: 0, owner_id: current_userid.to_s)
            Cardnote.create(
              text: "Transfer of card has been completed",
              create_date: Time.new(),
              card_id: transfer.asset_id.to_s
            )
            result[:info] = "Transfer has completed successfully"
            result[:asset] = transfer.asset_id
            result
          else
            result[:error] = "You can only accept this transfer if you are the recipient"
            result
          end
        else
          result[:error] = "Invalid card in transfer due to database inconsistency"
          result
        end
      else
        result[:error] = "Invalid transfer to accept"
        result
      end
    end
  end

  class Emailbot
    def self.send(from, to, subject, body)
      ActionMailer::Base.mail(from: from, to: to, subject: subject, body: body).deliver_now
    end
  end
end
