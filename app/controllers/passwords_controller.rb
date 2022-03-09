class PasswordsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_user, only: %i[edit update]

  def edit; end

  def update
    if password_params[:password].empty?
      @user.errors.add(:password, :blank)
      render :edit
    elsif @user.update!(password_params)
      @success = 'Your password has been updated!'
      render :edit
    else
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:token, :password, :password_confirmation)
  end

  def find_user
    token = DecodePasswordResetTokenService.new(params[:token])
    @user = User.find_by!(email: token.email)
  rescue JWT::ExpiredSignature
    flash[:danger] = 'Password reset has expired.'
  rescue JWT::DecodeError
    flash[:danger] = 'Token invalid.'
  end
end
