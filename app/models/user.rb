class User < ApplicationRecord
  has_many :videos, dependent: :destroy
  has_many :active_relationships,
           class_name: "Relationship", foreign_key: "user_id", dependent: :destroy

  def self.from_omniauth(auth)
      puts auth.to_json
      where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.image = auth.info.image
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.save!
      end
    end
end
