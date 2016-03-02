class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :authentication_social

  def facebook
  end

  def vkontakte
  end

  def instagram
  end

  protected

  def authentication_social
    result = Users::SaveSocialUsers.new(request.env["omniauth.auth"])
    if result.success?
      result.save_avatar!
      sign_in_and_redirect result.user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "#{result.user.provider.camelize}") if is_navigational_format?
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end
end
