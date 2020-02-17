class ApiUsers::SessionsController < Devise::SessionsController
  skip_before_action :require_no_authentication, only: [:create]
  skip_before_action :verify_signed_out_user, only: [:destroy]
  respond_to :json

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    render json: { token: self.resource.token }
  end

  # DELETE /resource/sign_out
  def destroy
    user = ApiUser.find_by_email(params[:api_user][:email])
    token = params[:api_user][:token]
    if !user.nil? and user.token == token
      user.update_attribute('token', '')
      BlockedToken.create!(token: token) 
      head :no_content
    end
  end

end
