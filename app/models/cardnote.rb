class Cardnote
  include Mongoid::Document
  store_in collection: "cardnotes"
  field :text, type: String
  field :create_date, type: Date

  field :card_id, type: BSON::ObjectId
end
