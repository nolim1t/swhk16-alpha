# Invitecode.create() will just make a random code
class Invitecode
  include Mongoid::Document
  store_in collection: "invitecodes"

  field :code, type: String, default: -> {s = "" ; 15.times{|i| s+='ABCDEFGHIJKLMNOPQRSTUVWXYZ'[rand(26), 1]} ; s}
  field :create_date, type: DateTime, default: ->{ Time.new }

  field :postprocess_instructions, type: String
  field :email, type: String
end
