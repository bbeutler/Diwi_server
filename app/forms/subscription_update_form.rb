class SubscriptionUpdateForm
  include ActiveModel::Model

  attr_accessor :is_active,
                :transaction_identifier,
                :subscription,
                :created_at

  def update!
    raise ActiveRecord::RecordInvalid.new self unless valid?

    ActiveRecord::Base.transaction do
      update_subscription! if is_active != nil
      create_receipt! if transaction_identifier
    end

    self
  end

  private

  def update_subscription!
    @subscription = subscription
     if is_active == true
      time = Time.new
      time.strftime("%Y-%m-%d %H:%M:%S")
      sql='UPDATE  "subscriptions" SET "subscriptions"."created_at" ="'+ Date.today.to_s + '" WHERE "subscriptions"."id" = '+ @subscription.id
      results = ActiveRecord::Base.connection.execute(sql) 
 #     # @subscription.created_at = Time.now
     end
    @subscription.is_active = is_active
    @subscription.save!
  end

  def create_receipt!
    @receipt = Receipt.create!(
      subscription: subscription,
      transaction_identifier: transaction_identifier
    )
  end
end