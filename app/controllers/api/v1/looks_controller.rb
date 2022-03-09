module Api
  module V1
    class LooksController < ApiController
      LOOK_ROOT = 'look'.freeze
      LOOKS_ROOT = 'looks'.freeze
      authorize_resource only: %i[create]
      load_and_authorize_resource only: %i[index show update destroy]

      def index
        render json: LookSerializer.render(
          @looks,
          root: LOOKS_ROOT,
          view: :index
        ), status: :ok
      end

      

      def show
        render_look_with(:ok)
      end

      def create
        look_params_with_consumer = look_params.merge(
          consumer: current_user.profile
        )

        look_form = LookCreateForm.new(look_params_with_consumer).save!
        @look = look_form.look

        render_look_with(:created)
      end

      def update
        look_params_with_consumer = update_look_params.merge(
          consumer: current_user.profile,
          look: @look
        )

        look_form = LookUpdateForm.new(look_params_with_consumer).update!
        @look = look_form.look

        render_look_with(:ok)
      end

      def destroy
        @look.destroy!

        render json: {
          look: { message: 'Deleted successfully' }
        }, status: :ok
      end

      private

      def look_params
        params.permit(:title,
                      :note,
                      :location,
                      dates_worn: [],
                      tag_ids: [],
                      photos: [],
                      videos: [])
      end

      def update_look_params
        params.permit(:title,
                      :note,
                      :location,
                      dates_worn: [],
                      tag_ids: [],
                      photos: [],
                      videos: [],
                      look_tag_ids_to_be_deleted: [],
                      dates_worn_to_be_deleted: [],
                      photo_ids_to_be_deleted: [],
                      video_ids_to_be_deleted: [])
      end

      def render_look_with(status)
        render json: LookSerializer.render(@look, root: LOOK_ROOT, view: :show),
               status: status
      end
    end
  end
end
