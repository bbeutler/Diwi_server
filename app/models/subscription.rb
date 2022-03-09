class Subscription < ApplicationRecord
  belongs_to :consumer
  has_many :receipts

  enum method_of_payment: { apple_store: 0, google_play: 1 }

  validates :consumer,
            :method_of_payment,
            :product_id,
            :product_name,
            presence: true

  validates :method_of_payment, inclusion: { in: method_of_payments.keys, message: :invalid }
end