class Cardcollection
  include Mongoid::Document
  store_in collection: "cardcollection"
  field :collectionname, type: String
end
