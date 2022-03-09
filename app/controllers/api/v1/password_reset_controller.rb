module Api
  module V1
    class PasswordResetController < ApiController
      skip_before_action :authenticate_user, only: :create

      def create
        user = User.find_by_email!(password_reset_params[:email])
        user_id = user.id

        ConsumerMailer.delay.password_reset(user_id, generate_jwt)

        render json: {
          password_reset: { message: 'password reset sent' }
        }, status: :created
      end

      private

      def generate_jwt
        JWT.encode(jwt_payload,
                   Rails.application.secrets[:secret_key_base],
                   'HS256')
      end

      def jwt_payload
        { exp: (Time.current + 24.hours).to_i,
          email: password_reset_params[:email] }
      end

      def password_reset_params
        params.require(:password_reset).permit(:email)
      end
    end
  end
end
