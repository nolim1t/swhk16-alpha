class Card
  include Mongoid::Document
  store_in collection: "cards"
  field :description, type: String
  field :front_url, type: String
  field :back_url, type: String

  # I'll keep owner stored as a string or id. Choose which way you wish to store the owner as
  field :owner_string, type: String
  field :owner_id, type: BSON::ObjectId
  
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
end
end
