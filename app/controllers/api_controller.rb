class ApiController < ActionController::API
  include Knock::Authenticable

  before_action :authenticate_user

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
  rescue_from CanCan::AccessDenied, with: :not_authorized

  def render_record_invalid(exception)
    render(json: { errors: exception.record.errors },
           status: :bad_request)
  end

  def render_not_found(exception)
    render(json: { errors: exception.message },
           status: :not_found)
  end

  def render_general_error(status:, message:)
    render(json: { errors: [message] },
           status: status)
  end

  def not_authorized
    render json: { error: ['unauthorized'] }, status: 401
  end
end
