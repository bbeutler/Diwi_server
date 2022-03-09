module Pushy
  module ApnAdapter
    class Async
      def self.call(token:, message:, metadata:)
        new(token, message, metadata).call
      end

      def initialize(token, message, metadata)
        @token      = token
        @message    = message
        @metadata   = metadata
      end

      def call
        connection.push_async(push)
        connection.join
        connection.close
      end

      private

      attr_reader :token, :message, :metadata

      def connection
        @connection ||= Apnotic::Connection.new(
          cert_path: cert_path,
          url: ENV['APN_URL']
        ) do |connection|
          connection.on(:error) do |exception|
            puts "Exception has been raised: #{exception}"
          end
        end
      end

      def notification
        notification = Apnotic::Notification.new(token)
        notification.alert = message
        notification.custom_payload = metadata || ''
        notification.topic = ENV['APNS_TOPIC']
        notification
      end

      def push
        push = connection.prepare_push(notification)
        push.on(:response) do |response|
          # Please keep below for debugging purposes!
          puts '################################# push APNS response'
          puts response.ok?
          puts response.status
          puts response.headers
          puts response.body
          puts '####################################################'

          if response.status == '410' ||
             (response.status == '400' &&
              response.body['reason'] == 'BadDeviceToken')

            puts "Destroying device token: #{token}"
            Device.find_by(device_token: token).destroy
          end
        end
        push
      end

      def cert_path
        Rails.root.join('config', 'certs', ENV['APNS_CERTIFICATE'])
      end
    end
  end
end
