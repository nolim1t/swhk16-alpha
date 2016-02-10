class Validationqueue
  include Mongoid::Document
  store_in collection: "validation_queue"

  field :entry_date, type: DateTime
  field :card_id, type: String # The card to validate
  field :requestor_email_address, type: String # Email address for person who requested it
end
