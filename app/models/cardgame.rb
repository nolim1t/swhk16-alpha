class Cardgame
  include Mongoid::Document
  store_in collection: "cardgame"

  field :gamename, type: String
  field :create_date, type: DateTime, default: ->{ Time.new }
end
