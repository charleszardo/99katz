class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :password, length: { minimum: 6, allow_nil: true }

  before_validation :ensure_session_token

  has_many :cats

  attr_accessor :password

  def self.find_by_credentials(hash)
    user = User.find_by_username(hash[:username])

    !user.nil? && user.password_digest.is_password?(hash[:password]) ? user : nil
  end

  def self.generate_session_token
    SecureRandom::base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def password_digest
    BCrypt::Password.new(super)
  end

  def is_password?(password)
    self.password_digest.is_password?(password)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save
  end

  def owns_cat?(cat_id)
    cats.find_by_id(cat_id)
  end

  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
