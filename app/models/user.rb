class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:facebook, :vkontakte, :instagram]

  mount_uploader :avatar, AvatarUploader


  def email_required?
    false if provider.present?
  end
  # def self.from_omniauth_facebook(auth)
  #   user = User.where(provider: auth.provider, uid: auth.uid).first

  #   if user.blank?
  #     pass = Devise.friendly_token[0,20]

  #     user = User.create(provider: auth.provider,
  #                             uid: auth.uid,
  #                           email: auth.info.email,
  #                        password: pass,
  #           password_confirmation: pass,
  #                            name: auth.info.name.split(' ')[0],
  #                         surname: auth.info.name.split(' ')[1])
  #   end

  #   user
  # end

  # def self.from_omniauth_vk(auth)
  #   user = User.where(provider: auth.provider, uid: auth.uid).first

  #   if user.blank?
  #     pass = Devise.friendly_token[0,20]

  #     user = User.create(provider: auth.provider,
  #                             uid: auth.uid,
  #                           email: auth.extra.raw_info.screen_name+"@vk.com",
  #                        password: pass,
  #           password_confirmation: pass,
  #                            name: auth.info.name.split(' ')[0],
  #                         surname: auth.info.name.split(' ')[1])
  #   end

  #   if user.persisted?
  #     user.remote_avatar_url = auth.info.image
  #     user.save
  #   end

  #   user
  # end

  def self.from_omniauth(auth)

    Rails.logger.info "auth -------------- #{auth.inspect.to_yaml}"

    user = User.where(provider: auth.provider, uid: auth.uid).first

    if user.blank?
      pass = Devise.friendly_token[0,20]

      user = User.create(provider: auth.provider,
                              uid: auth.uid,
                         password: pass,
            password_confirmation: pass,
                             name: auth.info.name.split(' ')[0],
                          surname: auth.info.name.split(' ')[1],
                            email: auth.info.name.split(' ')[0]+"@#{auth.provider}.com")
    end

    # if user.provider == "facebook"
    #   user.update_attributes(email: auth.info.email)
    # elsif user.provider == "vkontakte"
    #   user.update_attributes(email: auth.extra.raw_info.screen_name+"@vk.com")
    # else
    #   user.update_attributes(email: auth.extra.raw_info.username+"@instagram.com")
    # end

    if user.persisted? && user.provider != "facebook"
      user.remote_avatar_url = auth.info.image
      user.save
    end

    user
  end

end



  # def self.from_omniauth(auth)

  #   Rails.logger.info "auth -------------- #{auth.inspect.to_yaml}"

  #   existing_user = User.where(provider: auth.provider, uid: auth.uid).first

  #   if existing_user.present?
  #     # existing_user.load_picture_from_facebook
  #   else
  #     pass = Devise.friendly_token[0,20]

  #     user = User.new(
  #       provider: auth.provider,
  #       uid: auth.uid,
  #       email: auth.info.email,
  #       password: pass,
  #       password_confirmation: pass,
  #       name: auth.info.name.split(' ')[0],
  #       surname: auth.info.name.split(' ')[1]
  #     )

  #     if user.save
  #       # user.load_picture_from_facebook
  #     end
  #   end
  # end

  # def load_picture_from_facebook
  #   url = "http://graph.facebook.com/#{uid}?fields=picture.width(600)&format=json"

  #   Rails.logger.info "url ---------------------- #{url}"

  #   response = RestClient.get(url).body
  #   Rails.logger.info "response ---------------------- #{response.inspect}"

  #   parsed_info = JSON.parse(response)

  #   Rails.logger.info "parsed_info ---------------------- #{parsed_info.inspect}"

  #   Rails.logger.info "arsed_info['picture'] ---------------------- #{parsed_info['picture'].inspect}"

  #   Rails.logger.info "parsed_info['picture']['data'] ---------------------- #{parsed_info['picture']['data'].inspect}"

  #   if parsed_info['picture'].present? && parsed_info['picture']['data'].present?
  #     remote_avatar_url(parsed_info['picture']['data']['url'])
  #     save
  #   end
  # end
