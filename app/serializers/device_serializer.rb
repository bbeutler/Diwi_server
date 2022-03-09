class DeviceSerializer < ApplicationSerializer
  identifier :id

  fields :platform, :device_token
end
