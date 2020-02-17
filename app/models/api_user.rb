class ApiUser < ApplicationRecord
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
      user_type: 'api',
      iat: iat, 
      jti: jti
    }
    token = JWT.encode payload, self.secret_key, 'HS256', { :typ => "JWT" }

    self.update_without_password({token: token})
  end

end
