class Cardimage
  include Mongoid::Document
  store_in collection: "cardimages"

  field :create_date, type: Date
  field :card_id, type: BSON::ObjectId
  field :image_type, type: String # Enforce in app as 'front' or 'back'
  field :image_note, type: String
  mount_uploader :photo, CarduploaderUploader
end
