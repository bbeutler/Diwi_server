require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::UserTokenController, type: :request do
  TOKEN_TAG = 'Logins'.freeze

  describe 'User Token API', swagger_doc: 'v1/swagger.json' do
    let!(:user_one) do
      create(:user,
             :consumer_user,
             password: 'password',
             password_confirmation: 'password')
    end

    # CREATE
    path '/api/v1/user_token' do
      post 'Creates user token' do
        tags TOKEN_TAG
        description "\n Generate an authentication token for a user on login."
        consumes 'application/json'
        produces 'application/json'
        parameter name: :auth, in: :body, schema: {
          type: :object,
          properties: {
            email: { type: :string },
            password: { type: :string }
          }
        }

        let!(:good_auth_params) { { auth: { email: user_one.email, password: 'password' } } }
        let!(:invalid_params) { { auth: { email: user_one.email, password: 'badpassword' } } }

        response '201', 'User token created. User logged in.' do
          let!(:auth) { good_auth_params }

          it 'responds with 201 Created', request_example: :auth do
            expect(response).to have_http_status :created
          end

          it 'returns expected attributes in valid JSON', :skip_swagger do
            token = JSON.parse(response.body)['user']['token']
            expect(response.body).to include UserSerializer.render(User.first,
                                                                   root: 'user',
                                                                   view: :create,
                                                                   token: token)
          end
        end

        response '404', 'User not found' do
          context 'with invalid data' do
            let!(:auth) { invalid_params }

            it 'responds with 404 not found' do
              expect(response).to have_http_status :not_found
            end
          end
        end
      end
    end
  end
end
