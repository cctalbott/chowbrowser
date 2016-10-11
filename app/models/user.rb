class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role
  has_many :restaurants, :through => :locations
  has_many :sales_offices, :through => :locations
  has_many :orders
  has_one :delivery_driver
  has_one :clock_in
  has_one :sales_person
  has_and_belongs_to_many :locations
  before_validation :ensure_role_is_set
  validates_length_of :password, :minimum => 6, :message => "password must be at least 6 characters long", :if => :password
  validates_confirmation_of :password, :message => "should match confirmation", :if => :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  #validates_presence_of :username
  #validates_uniqueness_of :username

  ROLES = %w[admin editor restaurant_owner restaurant_editor customer guest]

  def role_symbols
    [role.to_sym]
  end

  def role?(role_name)
    role.eql?(role_name.to_s)
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.where(:email => data.email).first
      user
    else # Create a user with a stub password.
      User.create!(:email => data.email, :password => Devise.friendly_token[0,20], :role => "customer")
    end
  end

  def self.find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info
    if user = User.where(:email => data["email"]).first
      user
    else
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20], :role => "customer")
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end

  def is_driver?
    if self.delivery_driver && self.delivery_driver.length > 0
      return true
    else
      return false
    end
  end

  protected
    def ensure_role_is_set
      if role.nil?
        self.role = "guest"
      end
    end
end
