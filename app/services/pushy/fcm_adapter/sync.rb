module Pushy
  module FcmAdapter
    class Sync
      FCM_URL = 'https://fcm.googleapis.com'.freeze

      def self.call(token:, message:, metadata: nil)
        new(token, message, metadata).call
      end

      def initialize(token, message, metadata)
        @token = token
        @message = message
        @metadata = metadata
      end

      def call
        results = JSON.parse(fcm_response.body)['results']

        results.each do |result|
          Pushy::FcmAdapter::Result.process(result, token)
        end
      end

      private

      attr_reader :token, :message, :metadata

      def fcm_response
        connection.post do |request|
          request.url('/fcm/send')
          request.headers['Content-Type'] = 'application/json'
          request.headers['Authorization'] = 'key=' + ENV['FCM_SERVER_KEY']
          request.body = body
        end
      end

      def connection
        Faraday.new(url: FCM_URL)
      end

      def body
        {
          to: token,
          notification: {
            title: 'DiWi',
            body: message
          },
          data: metadata
        }.to_json
      end
    end
  end
end
