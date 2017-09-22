class Video < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc)}
  validates :user_id, presence: true
  class Video < ActiveRecord::Base
    YT_LINK_FORMAT = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i

    validates :link, presence: true, format: YT_LINK_FORMAT
  end
end
