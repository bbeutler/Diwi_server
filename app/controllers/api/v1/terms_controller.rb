module Api
  module V1
    class TermsController < ApiController
      skip_before_action :authenticate_user

      def index
        terms = File.read(Rails.root.to_s + '/public/terms.txt')
        render json: { terms: terms }, status: :ok
      end
    end
  end
end
