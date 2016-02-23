class Cardcollection
  include Mongoid::Document
  store_in collection: "cardcollection"
  
  field :collectionname, type: String
  field :create_date, type: DateTime, default: ->{ Time.new }
end
