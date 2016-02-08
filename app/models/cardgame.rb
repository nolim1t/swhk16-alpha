class Cardgame
  include Mongoid::Document
  store_in collection: "cardgame"

  field :gamename, type: String
end
