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
end
