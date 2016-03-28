class Card
  include Mongoid::Document
  store_in collection: "cards"
  #attr_accessible :image

  field :description, type: String
  field :cardname, type: String
  field :cardgame, type: String
  field :cardcollection, type: String
  field :create_date, type: DateTime, default: ->{ Time.new }
  field :update_date, type: DateTime, default: ->{ Time.new }
  field :card_condition, type: String # Should be either 'mint', 'slightly worn', 'damaged'
  field :validation_status, type: Integer, default: 0 # 0 = Unverified, 1 = Pending, 2 = Validated
  field :transfer_status, type: Integer, default: 0 # 0 = not being transferred, 1 = Pending (lets filter by this)
  field :owner_id, type: String

  field :unique_identifier, type: String, default: -> {s = "VA-" ; 7.times{|i| s+='ABCDEFGHIJKLMNOPQRSTUVWXYZ'[rand(26), 1]} ; s = s + "-#{(Card.count + 1).to_s}"; s}

  # Deleted
  field :deleted_status, type: Integer, default: 0 # Not deleted, 1 = deleted

  # Text
  field :searchable_name, type: String

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

  mount_uploader :photo, CarduploaderUploader
  #don't delete yet
  # def self.find_with_pagination(params = {}, filters = {})
  #   WillPaginate::Collection.create(params[:page].to_i < 1 ? 1 : params[:page], per_page_for_page(params[:page])) do |pager|
  #     result = Card.all.limit(pager.per_page).offset(offset_for_page(params[:page])).where(filters)
  #     pager.replace result
  #     unless pager.total_entries
  #       # the pager didn't manage to guess the total count, do it manually
  #       pager.total_entries = self.count
  #     end
  #   end
  # end

  # def self.offset_for_page(page_number)
  #   page_number.to_i > 1 ? ((page_number.to_i - 2) * 8 + 7) : 0
  # end

  # def self.per_page_for_page(page_number)
  #   page_number.to_i > 1 ? 8 : 7
  # end
end
