module Api
  module V1
    class GlobalSearchController < ApiController
      SEARCH_ROOT = 'results'.freeze

      def create
        @results = Search::GlobalSearch.new(
          current_user.profile.id,
          search_params[:search_term]
        ).search

        render json: GlobalSearchSerializer.render(@results, root: SEARCH_ROOT),
               status: :ok
      rescue
        value = search_params[:search_term]

        render_general_error(
          status: :bad_request,
          message: "Unable to search for value #{value}"
        )
      end

      private

      def search_params
        params.require(:search).permit(:search_term)
      end
    end
  end
end
