class User
  include Mongoid::Document
  store_in collection: "users"
  attr_accessor :invite_code, :signup_account_type

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time


  field :name, type: String
  field :timezone, type: String
  field :identity_verified, type: Integer # 1 if user identity is verified (for later implementations)
  field :user_type, type: String # 'standard' or 'vendor'
  field :create_date, type: Date # For working out when the next billing day is

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
  validates_each :signup_account_type, :on => :create do |record, attr, value|
    puts "#{attr}=\"#{value}\""
  end

  validates_each :invite_code, :on => :create do |record, attr, value|
      puts "#{attr}=\"#{value}\""
      record.errors.add attr, "Please enter correct invite code" unless
        value && value == "12345"
  end
end
