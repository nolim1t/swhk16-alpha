class Transfer
  include Mongoid::Document
  store_in collection: "assettransfers"

  field :asset_id, type: String # This is the representation of a card_id
  field :asset_type, type: String, default: "card" # For now, card
  field :sender_email, type: String # Who is sending
  field :receiver_email, type: String # Who is receiving
  field :arbiter_email, type: String, default: "info@vaultron.co" # Who is the middleman
  field :create_date, type: Date
end
