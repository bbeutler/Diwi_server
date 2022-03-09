class Receipt < ApplicationRecord
  belongs_to :subscription

  validates :subscription,
            :transaction_identifier,
            presence: true
end