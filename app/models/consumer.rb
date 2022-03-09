class Consumer < ApplicationRecord
  has_one :user, as: :profile
  has_one :subscription

  has_many :looks, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_one  :terms_acceptance, dependent: :destroy
  has_many :devices, dependent: :destroy

  def serializer
    ConsumerSerializer
  end
end
