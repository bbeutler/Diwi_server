module Pushy
  module Push
    def self.notify(device:, message:, metadata: nil)
      case device.platform
      when 'apn'
        Pushy::ApnAdapter::Async.call(token: device.device_token,
                                      message: message,
                                      metadata: metadata)
      when 'fcm'
        Pushy::FcmAdapter::Sync.call(token: device.device_token,
                                     message: message,
                                     metadata: metadata)
      end
    end
  end
end
