module Api
  module V1
    class UserTokenController < Knock::AuthTokenController
      skip_before_action :verify_authenticity_token
      USER_ROOT = 'user'.freeze

      def create
        @auth_token = auth_token

        render json: UserSerializer.render(
          user_from_payload,
          root: USER_ROOT,
          view: :create,
          token: @auth_token.token
        ), status: :created
      end

      private

      def user_from_payload
        User.from_token_payload(@auth_token.payload)
      end
    end
  end
end
