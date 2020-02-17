class Users::SessionsController < Devise::SessionsController
  skip_before_action :require_no_authentication, only: [:create, :check]
  skip_before_action :verify_signed_out_user, only: [:destroy]
  respond_to :json

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    render json: { token: self.resource.token }
  end

  # DELETE /resource/sign_out
  def destroy
    user = User.find_by_email(params[:user][:email])
    token = params[:user][:token]
    if !user.nil? and user.token == token
      user.update_attribute('token', '')
      BlockedToken.create!(token: token) 
      head :no_content
    end
  end

  def check
    header = request.headers['HTTP_AUTHORIZATION']
    return invalid_status unless header =~ /Bearer /i 
    token = header.split(' ')[1]

    if token_decode(token)
      valid_status
    else
      invalid_status
    end
  end

  private

  def invalid_status
    render json: { status: 'invalid' }, status: :unauthorized
  end

  def valid_status
    render json: { status: 'valid' }
  end

  def token_decode(encoded_token)
    begin
      options, payload = encoded_token.split('.')
      options = JSON.parse(Base64.decode64(options), { symbolize_names: true } )
      payload = JSON.parse(Base64.decode64(payload), { symbolize_names: true } )

      user = User.find_by_email(payload[:user])
      return false if user.token.empty?

      decoded = JWT.decode encoded_token, user.secret_key, true, { algorithm: options[:alg] }
      true
    rescue
      false
    end
  end

end
