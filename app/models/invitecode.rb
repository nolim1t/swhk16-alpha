# Invitecode.create() will just make a random code
class Invitecode
  include Mongoid::Document
  store_in collection: "invitecodes"

  field :code, type: String, default: -> {'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[rand(26), 10] + 'AEIOU'[rand(5), 10]}
  field :create_date, type: DateTime, default: ->{ Time.new }

  field :postprocess_instructions, type: String
  field :email, type: String
end
