require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::LooksController, type: :request do
  include AuthHelper
  LOOK_ROOT = 'look'.freeze
  LOOK_TAG  = 'Looks'.freeze

  describe 'Looks API', swagger_doc: 'v1/swagger.json' do
    let!(:user_one) { create(:user, :consumer_user) }
    let!(:user_one_consumer) { user_one.profile }
    let!(:user_two) { create(:user, :consumer_user) }
    let!(:user_one_looks) do
      create_list(:look,
                  3,
                  :has_tags,
                  :has_photos,
                  consumer: user_one.profile)
    end
    let!(:tags) { user_one_looks.map(&:tags).flatten }

    # INDEX
    path '/api/v1/looks' do
      get 'Retrieves list of looks for consumer' do
        tags LOOK_TAG
        description "\n Currently there is an error in the documentation preventing the index example response from displaying. \
                    The index returns the following attributes for looks: Title, Location, Dates Worn, Notes, Photo URLs (image and smaller thumbnail)."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]

        response '200', 'Looks list found' do
          let!(:Authorization) { auth_headers_for(user_one) }

          schema schema: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: {
                  '$ref' => '#/definitions/look'
                }
              }
            }
          }

          it 'responds with 200 OK' do
            expect(response).to have_http_status :ok
          end

          # TODO: Index requests are not returning the expected response body in testing at this time
          # it 'responds with all looks' do
          #   expect(JSON.parse(response.body)['looks'].count).to eq(3)
          # end
        end
      end
    end

    # SHOW
    path '/api/v1/looks/{id}' do
      get 'Retrieves a look for a consumer' do
        tags LOOK_TAG
        description "\n Show more detail for a look by using the look's id."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :id, in: :path, type: :string

        response '200', 'Look found' do
          let!(:Authorization) { auth_headers_for(user_one) }
          schema '$ref' => '#/definitions/look'
          let!(:id) { user_one_looks.first.id }

          it 'responds with 200 OK' do
            expect(response).to have_http_status :ok
          end

          it 'returns expected attributes in valid JSON', :skip_swagger do
            expect(response.body).to include LookSerializer.render(user_one_looks.first,
                                                                   root: LOOK_ROOT,
                                                                   view: :show)
          end
        end

        response '404', 'Event not found' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:id) { 'invalid' }

          it 'responds with 404 Not Found' do
            expect(response).to have_http_status :not_found
          end
        end

        response '401', 'Unauthorized' do
          context 'when accessing another user\'s data' do
            let!(:Authorization) { auth_headers_for(user_two) }
            let!(:id) { user_one_looks.first.id }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end

          context 'when logged out' do
            let!(:Authorization) { non_auth_headers }
            let!(:id) { user_one_looks.first.id }

            it 'responds with 401 unauthorized', :skip_swagger do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end

    # CREATE
    path '/api/v1/looks' do
      post 'Creates a look' do
        tags LOOK_TAG
        description "\n Create a look for a consumer. Title, dates worn and one photo are required."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :look, in: :body, schema: {
          type: :object,
          properties: {
            title: { type: :string },
            note: { type: :string },
            location: { type: :string },
            dates_worn: { type: :array },
            tag_ids: { type: :array },
            photos: { type: :array }
          }
        }

        let!(:valid_params) do
          {
            title: 'Best look ever',
            location: 'End of the year Banquet',
            note: 'I felt awesome wearing this outfit',
            dates_worn: ['2020/10/30'],
            tag_ids: tags.map(&:id),
            photos: [base_64_encoded_image, base_64_encoded_image]
          }
        end

        let!(:missing_photo_params) do
          {
            title: 'Best look ever but no pics...',
            location: 'End of the year Banquet',
            note: 'I felt awesome wearing this outfit',
            dates_worn: ['2020/10/30'],
            tag_ids: tags.map(&:id)
          }
        end

        let!(:minimal_params) do
          {
            title: '2nd Best look ever',
            dates_worn: ['2020/10/30'],
            photos: [base_64_encoded_image]
          }
        end

        let!(:invalid_params) do
          { dates_worn: ['Invalid Date'] }
        end

        response '201', 'Look created' do
          schema '$ref' => '#/definitions/look'
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:look) { valid_params }

          it 'responds with 201 OK', request_example: :look do
            expect(response).to have_http_status :created
          end

          it 'creates an look', :skip_swagger do
            created_look = Look.find_by(title: valid_params[:title])
            expect(created_look.title).to eql valid_params[:title]
            expect(created_look.tags.count).to eql valid_params[:tag_ids].count
          end

          it 'returns expected attributes in valid JSON', :skip_swagger do
            created_look = Look.find_by(title: valid_params[:title])
            expect(response.body).to include LookSerializer.render(created_look,
                                                                   root: LOOK_ROOT,
                                                                   view: :show)
          end
        end

        response '201', 'Look created' do
          context 'with minimal Params' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:look) { minimal_params }

            it 'responds with 201 OK', request_example: :look do
              expect(response).to have_http_status :created
            end

            it 'creates an look', :skip_swagger do
              created_look = Look.find_by(title: minimal_params[:title])
              expect(created_look.title).to eql minimal_params[:title]
              expect(created_look.photos.count).to eql minimal_params[:photos].count
            end

            it 'returns expected attributes in valid JSON', :skip_swagger do
              created_look = Look.find_by(title: minimal_params[:title])
              expect(response.body).to include LookSerializer.render(created_look,
                                                                    root: LOOK_ROOT,
                                                                    view: :show)
            end
          end
        end

        response '400', 'Bad Request' do
          context 'with invalid date format' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:look) { invalid_params }

            it 'responds with 400 Bad Request' do
              expect(response).to have_http_status :bad_request
            end
          end

          context 'with no photo provided' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:look) { missing_photo_params }

            it 'responds with 400 Bad Request' do
              expect(response).to have_http_status :bad_request
            end

            it 'responds with the expected error message' do
              expect(response.body).to include 'errors', 'photo', 'at least one photo is required'
            end
          end
        end

        response '401', 'Unauthorized' do
          context 'when not logged in' do
            let!(:Authorization) { non_auth_headers }
            let!(:look) { valid_params }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end

    # DESTROY
    path '/api/v1/looks/{id}' do
      delete 'Destroys a look' do
        tags LOOK_TAG
        description "\n Delete a look for a consumer."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :id, in: :path, type: :string

        response '200', 'Look deleted' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:id) { user_one_looks.last.id }

          it 'responds with 200 OK' do
            expect(response).to have_http_status :ok
          end

          it 'returns expected attributes in valid JSON', :skip_swagger do
            expect(response.body).to include 'Deleted successfully'
          end
        end

        response '404', 'Look not found' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:id) { 'invalid' }

          it 'responds with 404 Not Found' do
            expect(response).to have_http_status :not_found
          end
        end

        response '401', 'Unauthorized' do
          let!(:Authorization) { auth_headers_for(user_two) }
          let!(:id) { user_one_looks.last.id }

          context 'when a different user tries to delete an look' do
            it 'responds with 401 Unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end

    # UPDATE
    path '/api/v1/looks/{id}' do
      patch 'Updates an look' do
        tags LOOK_TAG
        description "\n Update a look for a consumer. At least one photo is required on a look."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :id, in: :path, type: :string
        parameter name: :look, in: :body, schema: {
          type: :object,
          properties: {
            title: { type: :string },
            note: { type: :string },
            location: { type: :string },
            dates_worn: { type: :array },
            tag_ids: { type: :array },
            photos: { type: :array },
            look_tag_ids_to_be_deleted: { type: :array },
            dates_worn_to_be_deleted: { type: :array },
            photo_ids_to_be_deleted: { type: :array }
          }
        }

        let!(:id) { user_one_looks.first.id }

        let!(:update_params) do
          {
            title: 'New look title',
            note: 'I have changed the note',
            dates_worn_to_be_deleted: [user_one_looks[0].dates_worn.first],
            photo_ids_to_be_deleted: [user_one_looks[0].photos.first.id]
          }
        end

        let!(:delete_tag_from_look_params) do
          {
            look_tag_ids_to_be_deleted: [user_one_looks[0].look_tags.first.id]
          }
        end

        let!(:invalid_update_params) do
          { dates_worn: ['Invalid Date'] }
        end

        let!(:missing_photos_update_params) do
          {
            title: 'Another new look title',
            photo_ids_to_be_deleted: [
              user_one_looks[1].photos.first.id,
              user_one_looks[1].photos.second.id
            ]
          }
        end

        response '200', 'Look Updated' do
          schema '$ref' => '#/definitions/look'
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:look) { update_params }

          it 'responds with 200 Look Updated', request_example: :look do
            expect(response).to have_http_status :ok
          end

          it 'should have updated Look', :skip_swagger do
            look = Look.first
            expect(look.title).to eq update_params[:title]
            expect(look.note).to eq update_params[:note]
            expect(look.dates_worn.count).to eq 1
            expect(look.photos.count).to eq(1)
          end
        end

        response '200', 'Look Relationships Updated' do
          schema '$ref' => '#/definitions/look'
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:look) { delete_tag_from_look_params }

          it 'responds with 200 Look Updated', request_example: :look do
            expect(response).to have_http_status :ok
          end

          it 'should have updated Look', :skip_swagger do
            look = Look.first
            expect(look.tags.count).to eq 0
            expect(look.look_tags.count).to eq 0
          end
        end

        response '400', 'Bad Request' do
          context 'with invalid date format' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:look) { invalid_update_params }

            it 'responds with 400 Bad Request' do
              expect(response).to have_http_status :bad_request
            end
          end

          context 'with removal of too many photos' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:look) { missing_photos_update_params }

            it 'responds with 400 Bad Request' do
              expect(response).to have_http_status :bad_request
            end

            it 'responds with the expected error message' do
              expect(response.body).to include 'errors', 'photo', 'at least one photo is required'
            end
          end
        end

        response '401', 'Unauthorized' do
          context 'when not logged in' do
            let!(:Authorization) { non_auth_headers }
            let!(:look) { update_params }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end
  end
end
