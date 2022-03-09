module Pushy
  module FcmAdapter
    class Result
      def self.process(result, token)
        new(result, token).process
      end

      def initialize(result, token)
        @result = result
        @token  = token
      end

      def process
        if result.key? 'error'
          handle_error
        elsif result.key? 'registration_id'
          update_device_token
        end
      end

      private

      attr_reader :result, :token

      def handle_error
        case result['error']
        when 'InvalidRegistration'
          device.destroy
        when 'NotRegistered'
          device.destroy
        end
      end

      def update_device_token
        device.update device_token: result['registration_id']
      end

      def device
        Device.find_by!(device_token: token)
      end
    end
  end
end
