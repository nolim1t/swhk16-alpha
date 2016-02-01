class Cardimage
  include Mongoid::Document
  store_in collection: "cardimages"
  attr_accessible :image

  field :url, type: String
  field :create_date, type: Date

  field :card_id, type: BSON::ObjectId

  mount_uploader :avatar, CarduploaderUploader
end
