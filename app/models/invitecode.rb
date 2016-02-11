class Invitecode
  include Mongoid::Document
  store_in collection: "invitecodes"

  field :code, type: String
  field :create_date, type: Date

  field :postprocess_instructions, type: String
end
