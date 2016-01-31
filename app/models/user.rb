class User
  include Mongoid::Document
  store_in collection: "users"

  field :name, type: String
  field :email, type: String
  field :password, type: String # Store hash of the password
  field :verified, type: Integer # 1 if user identity is verified (for later implementations)
  field :create_date, type: Date # For working out when the next billing day is

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
