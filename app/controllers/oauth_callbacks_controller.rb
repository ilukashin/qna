class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect(@user, event: :authentications)
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def facebook
    auth = request.env['omniauth.auth']

    if Authorization.where(provider: auth.provider, uid: auth.uid).first
      @user = User.find_for_oauth(auth)
      if @user&.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      else
        redirect_to root_path, alert: 'Something went wrong'
      end
    else
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      @user = User.new
      render 'shared/facebook_oauth'
    end
  end

end
