require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::TagsController, type: :request do
  include AuthHelper
  TAG_ROOT = 'tag'.freeze
  TAGS_ROOT = 'tags'.freeze
  TAGS_TAG = 'Tags'.freeze

  describe 'Tags API', swagger_doc: 'v1/swagger.json' do
    let!(:user_one) { create(:user, :consumer_user) }
    let!(:looks) { create_list(:look, 3, :has_photos, :has_tags, consumer: user_one.profile) }
    let!(:tags) { looks.map(&:tags).flatten }
    let!(:user_two) { create(:user, :consumer_user) }

    # INDEX
    path '/api/v1/tags' do
      get 'Retrieves list of tags' do
        tags TAGS_TAG
        description "\n Currently there is an error in the documentation preventing the index example response from displaying. \
                     The index returns the following attributes for tags: title, created_id and id."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]

        response '200', 'Tags list found' do
          let!(:Authorization) { auth_headers_for(user_one) }
          schema schema: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: {
                  '$ref' => '#/definitions/tags'
                }
              }
            }
          }

          it 'responds with 200 OK' do
            expect(response).to have_http_status :ok
          end

          # TODO: Index requests are not returning the expected response body in testing at this time
          # it 'responds with all tags', :skip_swagger do
          #   expect(JSON.parse(response.body)['tags'].count).to eq(3)
          # end
        end

        response '401', 'Unauthorized' do
          context 'when not logged in' do
            let!(:Authorization) { non_auth_headers }

            it 'responds with 401 unauthorized', :skip_swagger do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end

    # SHOW
    path '/api/v1/tags/{id}' do
      get 'Retrieves a tag for a consumer' do
        tags TAGS_TAG
        description "Show more detail for a tag with the tag's id."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :id, in: :path, type: :string

        response '200', 'Tag found' do
          let!(:Authorization) { auth_headers_for(user_one) }
          schema '$ref' => '#/definitions/tag'
          let!(:id) { tags.first.id }

          it 'responds with 200 OK' do
            expect(response).to have_http_status :ok
          end

          it 'returns expected attributes in valid JSON', :skip_swagger do
            expect(response.body).to include TagSerializer.render(tags.first,
                                                                  root: TAG_ROOT,
                                                                  view: :show)
          end
        end

        response '404', 'Tag not found' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:id) { 'invalid' }

          it 'responds with 404 Not Found' do
            expect(response).to have_http_status :not_found
          end
        end

        response '401', 'Unauthorized' do
          context 'when accessing another user\'s data' do
            let!(:Authorization) { auth_headers_for(user_two) }
            let!(:id) { tags.first.id }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end

          context 'when logged out' do
            let!(:Authorization) { non_auth_headers }
            let!(:id) { tags.first.id }

            it 'responds with 401 unauthorized', :skip_swagger do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end

    # DESTROY
    path '/api/v1/tags/{id}' do
      delete 'Destroys a tag' do
        tags TAGS_TAG
        description "\n Delete a tag for a consumer."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :id, in: :path, type: :string

        response '200', 'Tag deleted' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:id) { tags.last.id }

          it 'responds with 200 OK' do
            expect(response).to have_http_status :ok
          end

          it 'returns expected attributes in valid JSON', :skip_swagger do
            expect(response.body).to include 'Deleted successfully'
          end
        end

        response '404', 'Tag not found' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:id) { 'invalid' }

          it 'responds with 404 Not Found' do
            expect(response).to have_http_status :not_found
          end
        end

        response '401', 'Unauthorized' do
          let!(:Authorization) { auth_headers_for(user_two) }
          let!(:id) { tags.last.id }

          context 'when a different user tries to delete an tag' do
            it 'responds with 401 Unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end

    # CREATE
    path '/api/v1/tags' do
      post 'Creates a tag' do
        tags TAGS_TAG
        description "\n Create a tag for a consumer. Title is required. It can be linked to a look during creation."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :tag, in: :body, schema: {
          type: :object,
          properties: {
            title: { type: :string },
            look_ids: { type: :array }
          }
        }

        let!(:new_look) { create(:look, :has_photos, consumer: user_two.profile) }

        let!(:valid_params) do
          { title: tags.first.title,
            look_ids: [new_look.id] }
        end

        let!(:existing_tag_params) do
          { title: tags.first.title,
            look_ids: [looks.first.id] }
        end

        let!(:missing_params) do
          {}
        end

        response '201', 'Tag created' do
          let!(:Authorization) { auth_headers_for(user_two) }
          schema '$ref' => '#/definitions/tag'
          let!(:tag) { valid_params }

          it 'responds with 201 created', request_example: :tag do
            expect(response).to have_http_status :created
          end

          it 'creates a tag', :skip_swagger do
            created_tag = Tag.find_by(title: valid_params[:title])
            expect(created_tag.title).to eql valid_params[:title]
          end

          it 'returns expected attributes in valid JSON', :skip_swagger do
            created_tag = Tag.find_by(title: valid_params[:title], consumer_id: user_two.profile_id)
            expect(response.body).to include TagSerializer.render(created_tag,
                                                                  root: TAG_ROOT,
                                                                  view: :show)
          end
        end

        response '401', 'Unauthorized' do
          context 'when not logged in' do
            let!(:Authorization) { non_auth_headers }
            let!(:tag) { valid_params }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end
        end

        response '400', 'Unable to create tag' do
          schema '$ref' => '#/definitions/tag'
          let!(:Authorization) { auth_headers_for(user_one) }

          context 'with missing tags' do
            let!(:tag) { missing_params }

            it 'responds with 400 Bad Request' do
              expect(response).to have_http_status :bad_request
            end

            it 'responds with errors', :skip_swagger do
              expect(response.body).to include 'errors', 'title'
            end
          end

          context 'with already existing title for a tag' do
            let!(:tag) { existing_tag_params }

            it 'responds with 400 Bad Request', :skip_swagger do
              expect(response).to have_http_status :bad_request
            end

            it 'responds with has already been taken error' do
              expect(response.body).to include 'errors', 'title', 'has already been taken'
            end
          end
        end
      end
    end

    # UPDATE
    path '/api/v1/tags/{id}' do
      patch 'Updates an tag' do
        tags TAGS_TAG
        description "\n Update a tag for a consumer. It can be linked or removed from a look by provide look_ids and tag_look_ids."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :id, in: :path, type: :string
        parameter name: :tag, in: :body, schema: {
          type: :object,
          properties: {
            title: { type: :string },
            tag_ids: { type: :array },
            tag_look_ids_to_be_deleted: { type: :array }
          }
        }

        let!(:id) { tags.first.id }

        let!(:update_params) do
          {
            title: 'New Tag Title'
          }
        end

        let!(:invalid_update_params) do
          { title: nil }
        end

        response '200', 'Tag Updated' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:tag) { update_params }

          it 'responds with 200 Tag Updated', request_example: :tag do
            expect(response).to have_http_status :ok
          end

          it 'should have updated Tag', :skip_swagger do
            tag = Tag.first
            expect(tag.title).to eq update_params[:title]
          end
        end

        response '400', 'Bad Request' do
          context 'with invalid title' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:tag) { invalid_update_params }

            it 'responds with 400 Bad Request' do
              expect(response).to have_http_status :bad_request
            end
          end
        end

        response '401', 'Unauthorized' do
          context 'when not logged in' do
            let!(:Authorization) { non_auth_headers }
            let!(:tag) { update_params }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end
  end
end
