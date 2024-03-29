class Cardimage
  include Mongoid::Document
  store_in collection: "cardimages"

  field :create_date, type: DateTime, default: ->{ Time.new }
  field :card_id, type: BSON::ObjectId
  field :image_type, type: String # Enforce in app as 'front' or 'back'
  field :image_note, type: String
  mount_uploader :photo, CarduploaderUploader
  before_destroy :destroy_assets

  def destroy_assets
    self.photo.remove! if self.photo
    self.save!
  end
end
