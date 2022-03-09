require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::TermsController, type: :request do
  describe 'Terms API', swagger_doc: 'v1/swagger.json' do
    # INDEX
    path '/api/v1/terms' do
      get 'Retrieves terms' do
        tags 'Terms and Conditions'
        description "\n See the terms and conditions to be accepted."
        consumes 'application/json'
        produces 'application/json'

        response '200', 'Retrieves Terms and Conditions' do
          it 'responds with 200 OK' do
            expect(response).to have_http_status :ok
          end
        end
      end
    end
  end
end
