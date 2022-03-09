class ConsumerSerializer < ApplicationSerializer
  identifier :id

  fields :first_name, :last_name 

  association :devices, blueprint: DeviceSerializer
  association :subscription, blueprint: SubscriptionSerializer
end
