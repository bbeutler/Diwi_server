class TermsAcceptanceSerializer < ApplicationSerializer
  identifier :id

  fields :accepted_at, :remote_ip
end
