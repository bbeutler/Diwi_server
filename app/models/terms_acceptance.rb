class TermsAcceptance < ApplicationRecord
  belongs_to :consumer

  validates :consumer, :accepted_at, :remote_ip, presence: true

  def serializer
    TermsAcceptanceSerializer
  end
end
