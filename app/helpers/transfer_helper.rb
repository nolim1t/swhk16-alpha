module TransferHelper
  class Outgoing
    def self.send(from, to, assetid, assettype)
      result = {:info => "", :error => ""}
      if assettype == "card" then
        result[:info] = "Sending Asset #{assetid} to #{to} (originator: #{from})"
        result
      else
        result[:error] = "Invalid asset type"
        result
      end
    end
  end
end
