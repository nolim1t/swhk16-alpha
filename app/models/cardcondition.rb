class Cardcondition
  include Mongoid::Document
  store_in collection: "cardgame"

  field :condition, type: String
end
