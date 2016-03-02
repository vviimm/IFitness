module Users
  class SaveSocialUsers
    attr_reader :auth, :user

    def initialize(auth)
      @auth = auth

      Rails.logger.info "auth ------------------ #{@auth.inspect.to_yaml}"

      find_or_persist_user!
    end

    def success?
      user.persisted?
    end

    def save_avatar!
      if user.provider == "facebook"
        url = "https://graph.facebook.com/#{user.uid}/picture?type=large"
        user.remote_avatar_url = url
        user.save
      else
        url = auth.raw_info.extra.raw_info.photo_400_orig

        Rails.logger.info "url ------------------ #{url.inspect}"


        user.remote_avatar_url = url
        # user.remote_avatar_url = auth.info.image.gsub('http:','https:')
        user.save
      end
    end

  private

    def find_or_persist_user!
      @user = find_user
      @user = create_user! if user.blank?
      @user
    end

    def find_user
      User.where(provider: auth.provider, uid: auth.uid).first
    end

    def create_user!
      User.create(base_attrs)
    end

    def base_attrs
      pass = Devise.friendly_token[0,20]

      {
        provider: auth.provider,
        uid: auth.uid,
        password: pass,
        password_confirmation: pass,
        name: auth.info.name.split(' ')[0],
        surname: auth.info.name.split(' ')[1],
        confirmed_at: DateTime.now
      }
    end
  end
end


  # <extra=#<OmniAuth::AuthHash
  #     raw_info=#<OmniAuth::AuthHash
  #       bdate="16.3.1986"
  #       city=#<OmniAuth::AuthHash id=3249 title="Волжск">
  #       country=#<OmniAuth::AuthHash id=1 title="Россия">
  #       first_name="Vladimir"
  #       id=15567159
  #       last_name="Марухин"
  #       nickname=""
  #       online=1
  #       photo_100="http://cs623731.vk.me/v623731159/1ee86/2vZM3uZbEBI.jpg"
  #       photo_200="http://cs623731.vk.me/v623731159/1ee85/ajIOXDy_Oho.jpg"
  #       photo_200_orig="http://cs623731.vk.me/v623731159/1ee83/R79pio5eqC0.jpg"
  #       photo_400_orig="http://cs623731.vk.me/v623731159/1ee84/HRW318Lr0-Q.jpg"
  #       photo_50="http://cs623731.vk.me/v623731159/1ee87/nPc_bHRlsQY.jpg"
  #       screen_name="vviimm"
  #       sex=2>
  #     info=#<OmniAuth::AuthHash::InfoHash
  #       email=nil
  #       first_name="Vladimir"
  #       image="http://cs623731.vk.me/v623731159/1ee87/nPc_bHRlsQY.jpg"
  #       last_name="Марухин"
  #       location="Россия, Волжск"
  #       name="Vladimir Марухин"
  #       nickname=""
  #       urls=#<OmniAuth::AuthHash Vkontakte="http://vk.com/vviimm">
  #     provider="vkontakte"
  #     uid="15567159">
