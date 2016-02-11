module TransferHelper
  class Outgoing
    def self.send(from, to, assetid, assettype)
      if assettype == "card" then
        "Sending Asset #{assetid} to #{to} (originator: #{from})"
      else
        "Invalid asset type"
      end
    end
  end
end
