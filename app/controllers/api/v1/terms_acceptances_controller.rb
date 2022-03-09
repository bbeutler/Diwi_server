module Api
  module V1
    class TermsAcceptancesController < ApiController
      TERMS_ROOT = 'terms_acceptance'.freeze
      load_and_authorize_resource only: %i[create show]

      def create
        if terms_acceptance_params[:accepted_at].present?
          @terms_acceptance = TermsAcceptance.create!(
            consumer_id: terms_acceptance_params[:consumer_id],
            accepted_at: terms_acceptance_params[:accepted_at],
            remote_ip: request.remote_ip
          )

          render_terms_acceptance
        else
          render_terms_error
        end
      end

      def show
        render json: TermsAcceptanceSerializer.render(
          @terms_acceptance,
          root: TERMS_ROOT
        ), status: :ok
      end

      private

      def terms_acceptance_params
        params.require(:terms_acceptance).permit(:consumer_id,
                                                 :accepted_at)
      end

      def render_terms_error
        render_general_error(status: :bad_request,
                             message: 'Terms acceptance is required')
      end

      def render_terms_acceptance
        render json: TermsAcceptanceSerializer.render(
          @terms_acceptance,
          root: TERMS_ROOT
        ), status: :created
      end
    end
  end
end
