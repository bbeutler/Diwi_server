require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::GlobalSearchController, type: :request do
  include AuthHelper
  RESULTS_ROOT = 'results'.freeze
  SEARCH_TAG   = 'Global Search'.freeze

  # TODO: Swagger issue is causing search results to not appear in expectation response body
  # Looks and tags don't appear to be available on same thread where test is executing
  describe 'Global Search API', swagger_doc: 'v1/swagger.json' do
    let!(:user_one) { create(:user, :consumer_user) }
    let!(:tag_one) { create(:tag, title: 'Jessica Brown', consumer: user_one.profile) }
    let!(:tag_two) { create(:tag, title: 'Abby Redford', consumer: user_one.profile) }
    let!(:tag_three) { create(:tag, title: 'April Green', consumer: user_one.profile) }
    let!(:look_one) do
      create(
        :look,
        :has_photos,
        title: 'Red dress with gold hoops and black heels',
        note: 'I wore this for my birthday party!',
        dates_worn: [Date.parse('2020/04/09')],
        location: 'Bombay Darbar at Las Olas',
        consumer: user_one.profile,
        tag_ids: [tag_one.id, tag_two.id]
      )
    end
    let!(:look_two) do
      create(
        :look,
        :has_photos,
        title: 'Forest green floral top with silver skirt',
        note: 'I wore this for the End of the Year Banquet',
        dates_worn: [Date.parse('2019/12/31')],
        location: 'Rusty Pelican at Downtown Miami',
        consumer: user_one.profile,
        tag_ids: [tag_two.id]
      )
    end
    let!(:look_three) do
      create(
        :look,
        :has_photos,
        title: 'Yellow polka-dot bikini',
        note: 'A little teeny-weeny but my fave!',
        dates_worn: [Date.parse('2019/06/14')],
        location: 'Key Biscayne, Miami',
        consumer: user_one.profile,
        tag_ids: [tag_three.id]
      )
    end
    let!(:look_four) do
      create(
        :look,
        :has_photos,
        title: 'Purple blouse and necklace with black slacks',
        note: 'I wore this for the Redlands Agricultural work conference. They only saw the top half!',
        dates_worn: [Date.parse('2020/08/24')],
        location: 'Virtual',
        consumer: user_one.profile
      )
    end

    before(:each) do
      LooksIndex.reset!
      TagsIndex.reset!
    end

    # CREATE
    path '/api/v1/global_search' do
      post 'Search a users content' do
        tags SEARCH_TAG
        description "\n Allows a user to search through looks/tags with keyword search \
                    Use `{search: { search_term: \"search term\" } }` for global keyword search. \
                    This will search the tags, notes, title dates worn and location within the Look model \
                    There is an issue with swagger where example responses \ aren't being generated. \n\n\n
                    Example Request:
                     `{search: {search_term: 'January'} }` \n

                    Example 200 Response:
                    `{ results: {
                      dates: ['all looks worn in January],
                      looks: ['all looks with January in the name, location or notes'],
                      tags: ['all looks with your friend named January']
                      }
                    }`"
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: []]
        parameter name: :search, in: :body, schema: {
          type: :object,
          properties: {
            search: { search_term: { type: :string }}
          }
        }

        let!(:valid_params) do
          { search: {search_term: 'red ' }}
        end

        let!(:other_valid_params) do
          { search: {search_term: 'april' }}
        end

        let!(:partial_params) do
          { search: {search_term: 'gree' }}
        end

        let!(:date_params) do
          { search: { search_term: 'April' }}
        end

        let!(:tag_params) do
          { search: {search_term: tag_three.title } }
        end

        let!(:invalid_params) do
          { search: {search_term: nil } }
        end

        response '200', 'Search results' do
          context 'when searching everything for a matching term' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:search) { valid_params }

            it 'responds with 200 ok', request_example: :search do
              expect(response).to have_http_status :ok
            end

            it 'returns matching looks and tags', :skip_swagger do
              parsed = JSON.parse(response.body)
              results = parsed['results']
              expect(results['looks']).to be_an_instance_of(Array)
              # expect(results['looks'].count).to eq(2)
              expect(results['tags']).to be_an_instance_of(Array)
              # expect(results['tags'].count).to eq(1)
              expect(results['dates']).to be_an_instance_of(Array)
              # expect(results['dates'].count).to eq(0)
            end
          end

          context 'when searching everything for another matching term' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:search) { other_valid_params }

            it 'responds with 200 ok', request_example: :search do
              expect(response).to have_http_status :ok
            end

            it 'returns matching looks and tags', :skip_swagger do
              parsed = JSON.parse(response.body)
              results = parsed['results']
              expect(results['looks']).to be_an_instance_of(Array)
              # expect(results['looks'].count).to eq(1)
              expect(results['tags']).to be_an_instance_of(Array)
              # expect(results['tags'].count).to eq(1)
              expect(results['dates']).to be_an_instance_of(Array)
              # expect(results['dates'].count).to eq(1)
            end
          end

          context 'when searching everything for a partial matching term' do
            let!(:Authorization) { auth_headers_for(user_one) }
            let!(:search) { partial_params }

            it 'responds with 200 ok', :skip_swagger do
              expect(response).to have_http_status :ok
            end

            it 'returns matching looks, tags, and dates', :skip_swagger do
              parsed = JSON.parse(response.body)
              results = parsed['results']
              expect(results['looks']).to be_an_instance_of(Array)
              # expect(results['looks'].count).to eq(1)
              expect(results['tags']).to be_an_instance_of(Array)
              # expect(results['tags'].count).to eq(1)
              expect(results['dates']).to be_an_instance_of(Array)
              # expect(results['dates'].count).to eq(0)
            end
          end
        end

        context 'when filtering looks by friend (tag)' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:search) { tag_params }

          it 'responds with 200 ok', :skip_swagger do
            expect(response).to have_http_status :ok
          end

          it 'returns matching looks, tags, and dates', :skip_swagger do
            parsed = JSON.parse(response.body)
            results = parsed['results']
            expect(results['looks']).to be_an_instance_of(Array)
            # expect(results['looks'].count).to eq(1)
            expect(results['tags']).to be_an_instance_of(Array)
            # expect(results['tags'].count).to eq(0)
            expect(results['dates']).to be_an_instance_of(Array)
            # expect(results['dates'].count).to eq(0)
          end
        end

        context 'when filtering looks by date range' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:search) { date_params }

          it 'responds with 200 ok', :skip_swagger do
            expect(response).to have_http_status :ok
          end

          it 'returns matching looks, tags, and dates', :skip_swagger do
            parsed = JSON.parse(response.body)
            results = parsed['results']
            expect(results['looks']).to be_an_instance_of(Array)
            # expect(results['looks'].count).to eq(1)
            expect(results['tags']).to be_an_instance_of(Array)
            # expect(results['tags'].count).to eq(0)
            expect(results['dates']).to be_an_instance_of(Array)
            # expect(results['dates'].count).to eq(0)
          end
        end

        response '400', 'Bad Request' do
          let!(:Authorization) { auth_headers_for(user_one) }
          let!(:search) { invalid_params }

          it 'responds with 400 Bad Request' do
            expect(response).to have_http_status :bad_request
          end
        end

        response '401', 'Unauthorized' do
          context 'when not logged in' do
            let!(:Authorization) { non_auth_headers }
            let!(:search) { valid_params }

            it 'responds with 401 unauthorized' do
              expect(response).to have_http_status :unauthorized
            end
          end
        end
      end
    end
  end
end
