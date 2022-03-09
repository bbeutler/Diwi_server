class ReceiptSerializer < ApplicationSerializer
  identifier :id

  fields :transaction_identifier, :created_at
end