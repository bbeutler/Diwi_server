class SubscriptionCreateForm
  include ActiveModel::Model

  attr_accessor :consumer,
                :method_of_payment,
                :product_id,
                :product_name,
                :transaction_identifier,
                :subscription
                

  validate :consumer,
           :method_of_payment,
           :product_id,
           :product_name,
           :transaction_identifier

  def save!
    raise ActiveRecord::RecordInvalid.new self unless valid?

    ActiveRecord::Base.transaction do
      create_subscription!
      create_receipt!
    end

    self
  end

  private

  def create_subscription!
    @subscription = Subscription.create!(
      consumer: consumer,
      is_active: true,
      method_of_payment: method_of_payment,
      product_id: product_id,
      product_name: product_name
    )
  end

  def create_receipt!
    @receipt = Receipt.create!(
      subscription: @subscription,
      transaction_identifier: transaction_identifier
    )
  end
end