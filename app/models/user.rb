# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  secret_key             :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  token                  :string
#  token_exp              :datetime
#  organization_id        :integer
#
class User < ApplicationRecord
  belongs_to :organization

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :generate_secure_key

  def generate_secure_key
    self.secret_key = SecureRandom.hex(32)
  end

  def serializable_hash(options = {})
    {
      id: self.id,
      email: self.email, 
      token: self.token,
    }
  end

  def after_database_authentication
    iat = Time.now.to_i
    jti_raw = [self.secret_key, iat].join(':').to_s
    jti = Digest::SHA256.hexdigest(jti_raw)

    payload = { 
      user: self.email,
      user_type: 'web',
      exp: 12.hour.from_now.to_i,
      iat: iat, 
      jti: jti
    }
    token = JWT.encode payload, self.secret_key, 'HS256', { :typ => "JWT" }

    self.update_without_password({token: token})
  end
end
