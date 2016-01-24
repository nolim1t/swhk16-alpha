class User
  include Mongoid::Document
  field :name, type: String
  field :email, type: String
  field :oassword, type: String
  field :facebook_token, type: String

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
