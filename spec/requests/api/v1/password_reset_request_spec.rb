require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::PasswordResetController, type: :request do
  include AuthHelper
  PW_TAG = 'Password Resets'.freeze

  describe 'Password Reset API', swagger_doc: 'v1/swagger.json' do
    let!(:user_one) { create(:user, :consumer_user) }

    # CREATE
    path '/api/v1/password_reset' do
      post 'Creates password reset' do
        tags PW_TAG
        description "\n The password reset endpoint sends an email with a link for users to update their password. \
                     The password update view is in the API and does not need to be created in the front-end apps."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :id, in: :path, type: :string
        parameter name: :password_reset, in: :body, schema: {
          type: :object,
          properties: {
            email: { type: :string }
          }
        }

        let!(:reset_params) { { email: user_one.email } }
        let!(:invalid_params) { { email: 'invalidemail@test.com' } }

        response '201', 'Password reset created' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:id) { user_one.id }
          let!(:password_reset) { reset_params }

          it 'responds with 201 Created', request_example: :password_reset do
            expect(response).to have_http_status :created
          end

          it 'returns expected attributes in valid JSON', :skip_swagger do
            expect(response.body).to eql(
              { password_reset: {
                message: 'password reset sent'
              } }.to_json
            )
          end
        end

        response '404', 'User not found' do
          context 'with invalid data' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:id) { user_one.id }
            let!(:password_reset) { invalid_params }

            it 'responds with 404 not found' do
              expect(response).to have_http_status :not_found
            end
          end
        end
      end
    end
  end
end
