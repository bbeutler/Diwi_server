module Api
  module V1
    class DevicesController < ApiController
      load_and_authorize_resource only: :update

      def create
        @device_form = DeviceCreateForm.new(
          device_params_with_current_user
        ).save!

        @device = @device_form.device
        render_device_with(:created)
      end

      def update
        @device.update!(device_params)
        render_device_with(:ok)
      end

      private

      def device_params_with_current_user
        device_params.merge!(consumer: current_user.profile)
      end

      def device_params
        params.require(:device).permit(:device_token, :platform)
      end

      def render_device_with(status)
        render json: @device,
               serializer: DeviceSerializer,
               status: status
      end
    end
  end
end
