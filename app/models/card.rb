class Card
  include Mongoid::Document
  store_in collection: "cards"
  field :description, type: String

  field :owner_id, type: BSON::ObjectId # Store it as a BSON Object

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
