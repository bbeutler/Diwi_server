module Api
  module V1
    class TagsController < ApiController
      TAG_ROOT = 'tag'.freeze
      TAGS_ROOT = 'tags'.freeze
      authorize_resource only: %i[create]
      load_and_authorize_resource only: %i[index show destroy update]

      def index
        render json: TagSerializer.render(
          current_user.profile.tags,
          root: TAGS_ROOT,
          view: :index
        ), status: :ok
      end

      def create
        tag_params_with_consumer = tag_params.merge(
          consumer: current_user.profile
        )

        tag_form = TagCreateForm.new(tag_params_with_consumer).save!
        @tag = tag_form.tag

        render_tag_with(:created)
      end

      def update
        update_tag_params_with_consumer = update_tag_params.merge(
          consumer: current_user.profile,
          tag: @tag
        )

        update_form = TagUpdateForm.new(update_tag_params_with_consumer).update!
        @tag = update_form.tag

        render_tag_with(:ok)
      end

      def show
        render_tag_with(:ok)
      end

      def destroy
        @tag.destroy!

        render json: {
          tag: { message: 'Deleted successfully' }
        }, status: :ok
      end

      private

      def tag_params
        params.permit(:title,
                      look_ids: [])
      end

      def update_tag_params
        params.permit(:title,
                      look_ids: [],
                      tag_look_ids_to_be_deleted: [])
      end

      def render_tag_with(status)
        render json: TagSerializer.render(@tag, root: TAG_ROOT, view: :show),
               status: status
      end
    end
  end
end
