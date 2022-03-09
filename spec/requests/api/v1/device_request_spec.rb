require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::DevicesController, type: :request do
  include AuthHelper
  DEVICE_TAG = 'Device'.freeze

  describe 'Device API', swagger_doc: 'v1/swagger.json' do
    let!(:user_one) { create(:user, :consumer_user) }
    let!(:android_device) { create(:device, :consumer_android, consumer: user_one.profile) }

    # CREATE
    path '/api/v1/devices' do
      post 'Create a new device' do
        tags DEVICE_TAG
        description "\n Create a new device for a consumer so that they can recieve push notifications."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :device, in: :body, schema: {
          type: :object,
          properties: {
            platform: { type: :string },
            device_token: { type: :string }
          }
        }

        let!(:valid_params) do
          {
            platform: 'apn',
            device_token: 'some_test_token'
          }
        end

        response '201', 'Device created' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:device) { valid_params }
          schema '$ref' => '#/definitions/device'

          it 'responds with 200 ok', request_example: :device do
            expect(response).to have_http_status :created
          end
        end

        response '401', 'Unauthorized' do
          context 'when not logged in' do
            let!(:Authorization) { non_auth_headers }
            let!(:device) { valid_params }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end

    # UPDATE
    path '/api/v1/devices/{id}' do
      patch 'Update a device' do
        tags DEVICE_TAG
        description "\n Update a device for a consumer so that they can recieve push notifications."
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :id, in: :path, type: :string
        parameter name: :device, in: :body, schema: {
          type: :object,
          properties: {
            platform: { type: :string },
            device_token: { type: :string }
          }
        }

        let!(:valid_params) do
          {
            platform: 'apn',
            device_token: 'some_new_test_token'
          }
        end

        response '200', 'Device updated' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:device) { valid_params }
          let!(:id) { android_device.id }
          schema '$ref' => '#/definitions/device'

          it 'responds with 200 ok', request_example: :device do
            expect(response).to have_http_status :ok
          end
        end

        response '401', 'Unauthorized' do
          context 'when not logged in' do
            let!(:Authorization) { non_auth_headers }
            let!(:device) { valid_params }
            let!(:id) { android_device.id }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end
  end
end
