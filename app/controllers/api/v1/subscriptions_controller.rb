module Api
  module V1
    class SubscriptionsController < ApiController
      authorize_resource only: [:create]
      load_and_authorize_resource only: [:update, :show]
      SUBSCRIPTION_ROOT = 'subscription'.freeze

      def create
        subscription_form = SubscriptionCreateForm.new(subscription_params_with_consumer).save!
        @subscription = subscription_form.subscription
        render_subscription_with(:created)
      end

      def update
        subscription_form = SubscriptionUpdateForm.new(subscription_update_params).update!
        @subscription = subscription_form.subscription
        render_subscription_with(:ok)
      end

      def show
        render_subscription_with(:ok)
      end

      private

      def subscription_params_with_consumer
        subscription_create_params.merge(consumer: current_user.profile)
      end

      def subscription_create_params
        params.permit(:method_of_payment,
                      :product_id,
                      :product_name,
                      :is_active,
                      :transaction_identifier)
      end

      def subscription_update_params
        params.permit(:is_active, :transaction_identifier).merge(subscription: @subscription)
      end

      def render_subscription_with(status)
        render json: SubscriptionSerializer.render(@subscription, root: SUBSCRIPTION_ROOT),
               status: status
      end
    end
  end
end
