class Cardcondition
  include Mongoid::Document
  store_in collection: "cardcondition"

  field :condition, type: String
end
