class SubscriptionSerializer < ApplicationSerializer
  identifier :id

  fields :product_name, :product_id, :is_active, :method_of_payment, :created_at, :updated_at

  association :receipts, blueprint: ReceiptSerializer
end