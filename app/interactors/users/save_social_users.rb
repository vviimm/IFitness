module Users
  class SaveSocialUsers
    attr_reader :auth, :user

    def initialize(auth)
      @auth = auth
      find_or_persist_user!
    end

    def success?
      user.persisted?
    end

    private

      def find_or_persist_user!
        @user = find_user

        if user.blank?
          create_user!
        else
          update_user!
        end

             end

      def find_user
        User.where(provider: auth.provider, uid: auth.uid).first
      end

      def base_attrs
        pass = Devise.friendly_token[0,20]

        {
          provider: auth.provider,
          uid: auth.uid,
          password: pass,
          password_confirmation: pass,
          email: auth.info.name.split(' ')[0]+"@#{auth.provider}.com"
          name: auth.info.name.split(' ')[0],
          surname: auth.info.name.split(' ')[1],
        }
      end

      def create_user!
        User.create(base_attrs)
      end

      def save_avatar
        remote_avatar_url = auth.info.image
        save
      end


    # def from_omniauth



      user = User.where(provider: auth.provider, uid: auth.uid).first

      if user.blank?
        pass = Devise.friendly_token[0,20]

        user = User.create(provider: auth.provider,
                                uid: auth.uid,
                           password: pass,
              password_confirmation: pass,
                               name: auth.info.name.split(' ')[0],
                            surname: auth.info.name.split(' ')[1])
      end

      if user.provider == "facebook"
        user.update_attributes(email: auth.info.email)
      else
        user.update_attributes(email: auth.extra.raw_info.username+"@#{auth.provider}.com")
      end

      if user.persisted? && user.provider != "facebook"
        user.remote_avatar_url = auth.info.image
        user.save
      end

      user
    end
  end
end
