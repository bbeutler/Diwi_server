require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::TermsAcceptancesController, type: :request do
  include AuthHelper
  TERMS_ROOT = 'terms_acceptance'.freeze
  TERMS_TAG = 'Terms Acceptances'.freeze

  describe 'Terms Acceptances API', swagger_doc: 'v1/swagger.json' do
    let!(:user_one) { create(:user, :consumer_user) }
    let!(:user_two) { create(:user, :consumer_user) }
    let!(:terms_acceptance) { create(:terms_acceptance, consumer: user_one.profile)}

    # SHOW
    path '/api/v1/terms_acceptances/{id}' do
      get 'Retrieves a terms acceptance' do
        tags TERMS_TAG
        description "\n Retrieves a terms acceptance for a consumer."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :id, in: :path, type: :string

        response '200', 'Terms acceptance found' do
          let!(:Authorization) { auth_headers_for(user_one) }
          schema '$ref' => '#/definitions/terms_acceptance'
          let!(:id) { terms_acceptance.id }

          it 'responds with 200 OK' do
            expect(response).to have_http_status :ok
          end

          it 'returns expected attributes in valid JSON', :skip_swagger do
            expect(response.body).to eql(
              TermsAcceptanceSerializer.render(terms_acceptance, root: TERMS_ROOT)
            )
          end
        end

        response '404', 'Terms acceptance not found' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:id) { 'invalid' }

          it 'responds with 404 Not Found' do
            expect(response).to have_http_status :not_found
          end
        end

        response '401', 'Unauthorized' do
          context 'when accessing another user\'s data' do
            let!(:Authorization) { auth_headers_for(user_two) }
            let!(:id) { terms_acceptance.id }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end

          context 'when logged out' do
            let!(:Authorization) { non_auth_headers }
            let!(:id) { terms_acceptance.id }

            it 'responds with 401 unauthorized', :skip_swagger do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end

    # CREATE
    path '/api/v1/terms_acceptances' do
      post 'Creates a term acceptance' do
        tags TERMS_TAG
        description "\n Create a terms acceptance for a consumer."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :terms_acceptance, in: :body, schema: {
          type: :object,
          properties: {
            consumer_id: { type: :integer },
            accepted_at: { type: :string }
          }
        }

        let!(:valid_params) do
          { terms_acceptance: {
            consumer_id: user_two.profile.id,
            accepted_at: Time.current
          } }
        end

        let!(:invalid_params) do
          { terms_acceptance: {
            accepted_at: Time.current
          } }
        end

        response '201', 'Terms acceptance created' do
          let!(:Authorization) { auth_headers_for(user_two) }
          schema '$ref' => '#/definitions/terms_acceptance'
          let!(:terms_acceptance) { valid_params }

          it 'responds with 201 Created', request_example: :terms_acceptance do
            expect(response).to have_http_status :created
          end

          it 'successfully creates a terms acceptance', :skip_swagger do
            expect(TermsAcceptance.last.consumer_id).to eql valid_params[:terms_acceptance][:consumer_id]
          end

          it 'returns expected attributes in valid JSON', :skip_swagger do
            expect(response.body).to include TermsAcceptanceSerializer.render(TermsAcceptance.last,
                                                                              root: TERMS_ROOT)
          end
        end

        response '400', 'Unable to create terms acceptance' do
          let!(:Authorization) { auth_headers_for(user_one) }
          schema '$ref' => '#/definitions/terms_acceptance'
          let!(:terms_acceptance) { invalid_params }

          context 'with missing params' do
            it 'responds with 400 Bad Request' do
              expect(response).to have_http_status :bad_request
            end

            it 'responds with errors', :skip_swagger do
              expect(response.body).to include 'errors', 'consumer'
            end
          end
        end

        response '401', 'Unauthorized' do
          let!(:Authorization) { auth_headers_for(user_one) }
          schema '$ref' => '#/definitions/terms_acceptance'
          let!(:terms_acceptance) { valid_params }

          context 'when a different user tries to create a terms acceptance' do
            it 'responds with 401 Unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end
  end
end
