class Cardnote
  include Mongoid::Document
  store_in collection: "cardnotes"
  field :text, type: String
  field :create_date, type: DateTime

  field :card_id, type: String
end
