require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  include AuthHelper
  USER_ROOT = 'user'.freeze
  USER_TAG = 'Users'.freeze

  describe 'Users API', swagger_doc: 'v1/swagger.json' do
    let!(:user_one) { create(:user, :consumer_user) }
    let!(:user_two) { create(:user, :consumer_user) }

    # SHOW
    path '/api/v1/users/{id}' do
      get 'Retrieves a user' do
        tags USER_TAG
        description "\n Show more detail about a user with their id."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :id, in: :path, type: :string

        response '200', 'User found' do
          let!(:Authorization) { auth_headers_for(user_one) }
          schema '$ref' => '#/definitions/user'
          let!(:id) { user_one.id }

          it 'responds with 200 OK' do
            expect(response).to have_http_status :ok
          end

          it 'returns expected attributes in valid JSON' do
            expect(response.body).to eql(
              UserSerializer.render(user_one, root: USER_ROOT, view: :show)
            )
          end
        end

        response '404', 'User not found' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:id) { 'invalid' }

          it 'responds with 404 Not Found' do
            expect(response).to have_http_status :not_found
          end
        end

        response '401', 'Unauthorized' do
          context 'when accessing another user\'s data' do
            let!(:Authorization) { auth_headers_for(user_two) }
            let!(:id) { user_one.id }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end

          context 'when logged out' do
            let!(:Authorization) { non_auth_headers }
            let!(:id) { user_one.id }

            it 'responds with 401 unauthorized', :skip_swagger do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end

    # CREATE
    path '/api/v1/users' do
      post 'Creates a user' do
        tags USER_TAG
        description "\n Create a user during registration. The following are required: Email, \
                    password, password_confirmation, profile (consumer details), profile_type. \
                    The consumer profile (first_name and last_name) are not being \
                    used but remain in the API."
        consumes 'application/json'
        produces 'application/json'
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            email: { type: :string },
            password: { type: :string },
            password_confirmation: { type: :string },
            profile: { type: :object,
                       properties: {
                         id: { type: :integer },
                         first_name: { type: :string },
                         last_name: { type: :string }
                       } },
            profile_type: { type: :string }
          }
        }

        let!(:valid_params) do
          { email: Faker::Internet.email,
            password: '123123123',
            password_confirmation: '123123123',
            profile: {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name
            }, profile_type: 'consumer' }
        end

        let!(:missing_params) do
          {
            password: '123123123',
            password_confirmation: '123123123',
            profile: {
              first_name: Faker::Name.first_name,
            }, profile_type: 'consumer' }
        end

        let!(:invalid_params) do
          { email: 'not@good',
            password: '123123123',
            password_confirmation: '123123123',
            profile: {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name
            }, profile_type: 'consumer' }
        end

        response '201', 'User created/registered' do
          schema '$ref' => '#/definitions/user'
          let!(:user) { valid_params }

          it 'responds with 201 Created', request_example: :user do
            expect(response).to have_http_status :created
          end

          it 'successfully creates a user', :skip_swagger do
            expect(User.first.email).to eql valid_params[:email]
          end

          it 'returns expected attributes in valid JSON', :skip_swagger do
            token = JSON.parse(response.body)['user']['token']
            expect(response.body).to include UserSerializer.render(User.first,
                                                                   root: USER_ROOT,
                                                                   view: :create,
                                                                   token: token)
          end
        end

        response '400', 'Unable to create user' do
          schema '$ref' => '#/definitions/user'

          context 'with missing user data' do
            let!(:user) { missing_params }

            it 'responds with 400 Bad Request' do
              expect(response).to have_http_status :bad_request
            end

            it 'responds with errors', :skip_swagger do
              expect(response.body).to include 'errors', 'email'
            end
          end

          context 'with invalid email' do
            let!(:user) { invalid_params }

            it 'responds with 400 Bad Request', :skip_swagger do
              expect(response).to have_http_status :bad_request
            end

            it 'responds with errors', :skip_swagger do
              expect(response.body).to include 'errors', 'email'
            end
          end
        end
      end
    end

    # UPDATE
    path '/api/v1/users/{id}' do
      patch 'Updates a user' do
        tags USER_TAG
        description "\n Updates a user's email and/or their password. Current password is required for all updates. \
                        Correct current password and matching new passwords are required for a password update"
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :id, in: :path, type: :string
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            email: { type: :string },
            current_password: { type: :string },
            new_password: { type: :string },
            password_confirmation: { type: :string }
          }
        }

        let!(:update_email_params) { { email: 'newemail@test.com',
                                       current_password: user_one.password } }

        let!(:update_password_params) { { email: 'newemail@test.com',
                                          current_password: "#{user_one.password}",
                                          new_password: 'NEW-PASSWORD',
                                          password_confirmation: 'NEW-PASSWORD' } }
       let!(:mismatch_password_params) { { email: 'newemail@test.com',
                                            current_password: "#{user_one.password}",
                                            new_password: 'NEW-PASSWORD',
                                            password_confirmation: 'OOPS-PASSWORD' } }

        let!(:bad_password_params) { { email: 'newemail@test.com',
                                       current_password: "BAD-#{user_one.password}" } }
        response '200', 'User updated' do
          context 'Email Updated' do
            let!(:Authorization) { auth_headers_for(user_one) }
            schema '$ref' => '#/definitions/user'
            let!(:id) { user_one.id }
            let!(:user) { update_email_params }

            it 'responds with 200 OK', request_example: :user do
              expect(response).to have_http_status :ok
            end

            it 'updates the record', :skip_swagger do
              user = User.find(user_one.id)
              expect(user.email).to eql 'newemail@test.com'
            end

            it 'returns expected attributes in valid JSON', :skip_swagger do
              user = User.find(user_one.id)
              expect(response.body).to eql(
                UserSerializer.render(user, root: USER_ROOT, view: :update)
              )
            end
          end

          context 'User Password updated' do
            let!(:Authorization) { auth_headers_for(user_one) }
            schema '$ref' => '#/definitions/user'
            let!(:id) { user_one.id }
            let!(:user) { update_password_params }

            it 'responds with 200 OK', request_example: :user do
              expect(response).to have_http_status :ok
            end

            it 'updates the record', :skip_swagger do
              user = User.find(user_one.id)
              expect(user.authenticate(update_password_params[:new_password])).to eql user
            end

            it 'returns expected attributes in valid JSON', :skip_swagger do
              user = User.find(user_one.id)
              expect(response.body).to eql(
                UserSerializer.render(user, root: USER_ROOT, view: :update)
              )
            end
          end
        end

        response '400', 'Bad Request' do
          context 'when providing mismatched passwords' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:id) { user_one.id }
            let!(:user) { mismatch_password_params }

            it 'responds with 400 Bad request' do
              expect(response).to have_http_status :bad_request
            end
          end
        end

        response '401', 'Unauthorized' do
          context 'when not providing the correct password' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:id) { user_one.id }
            let!(:user) { bad_password_params }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end

          context 'when updating another user\'s data' do
            let!(:Authorization) { auth_headers_for(user_two) }
            let!(:id) { user_one.id }
            let!(:user) { update_email_params }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end
  end
end
