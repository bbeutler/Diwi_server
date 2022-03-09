class Device < ApplicationRecord
  belongs_to :consumer

  validates :device_token, :platform, :consumer, presence: true
  enum platform: { apn: 0, fcm: 1 }

  validates :platform, inclusion: { in: platforms.keys, message: :invalid }
end
