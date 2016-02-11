module TransferHelper
  class Outgoing
    def self.send(from, to, assetid, assettype)
      result = {:info => "", :error => ""}
      if assettype == "card" then
        recipient = User.where(email: to)
        if recipient.count == 1 then
          puts "Recipient: #{recipient[0][:email]}"
          begin
            card = Card.find(assetid)
          rescue
            card = nil
          end
          if card != nil
            puts "#{card}"
            result[:info] = "Sending Asset #{assetid} to #{to} (originator: #{from})"
            result
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
  end
end
