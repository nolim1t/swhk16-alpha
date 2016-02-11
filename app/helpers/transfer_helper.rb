module TransferHelper
  class Outgoing
    def self.send(from, to, assetid, assettype)
      "Sending Asset #{assetid} to #{to} (originator: #{from})"
    end
  end
end
