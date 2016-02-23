class Cardcondition
  include Mongoid::Document
  store_in collection: "cardcondition"

  field :condition, type: String
  field :create_date, type: DateTime, default: ->{ Time.new }
end
