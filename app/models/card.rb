class Card
  include Mongoid::Document
  store_in collection: "cards"
  #attr_accessible :image

  field :description, type: String
  field :cardname, type: String
  field :cardgame, type: String
  field :cardcollection, type: String
  field :create_date, type: Date
  field :update_date, type: Date
  field :owner_id, type: String

  # Types of fields
  # Array
  # BigDecimal
  # Boolean
  # Date
  # DateTime
  # Float
  # Hash
  # Integer
  # BSON::ObjectId
  # BSON::Binary
  # Range
  # Regexp
  # String
  # Symbol
  # Time
  # TimeWithZone

  mount_uploader :photo, CarduploaderUploader
end
