class Cardimage
  include Mongoid::Document
  store_in collection: "cardimages"

  field :url, type: String
  field :create_date, type: Date

  field :card_id, type: BSON::ObjectId

end
