class DeviceCreateForm
  include ActiveModel::Model

  attr_accessor :consumer, :platform, :device_token

  attr_reader :device

  validates :consumer, :platform, :device_token, presence: true

  def save!
    raise ActiveRecord::RecordInvalid, self unless valid?

    ActiveRecord::Base.transaction do
      find_device
      save_device
    end

    self
  end

  private

  def find_device
    @existing_device = Device.find_by(consumer: consumer, platform: platform)
  end

  def save_device
    if @existing_device.nil?
      create_device
    else
      update_device
    end
  end

  def create_device
    @device = Device.create!(consumer: consumer,
                             platform: platform,
                             device_token: device_token)
  end

  def update_device
    @existing_device.update!(device_token: device_token, platform: platform)
    @device = @existing_device
  end
end
