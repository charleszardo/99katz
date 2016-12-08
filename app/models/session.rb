class Session < ActiveRecord::Base
  valides :session_token, :user_id, presence: true

  belongs_to :user

  def self.generate_session_token
    SecureRandom::base64(16)
  end
end
