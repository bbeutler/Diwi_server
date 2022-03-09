class UserUpdateForm
  include ActiveModel::Model

  attr_accessor :email,
                :current_password,
                :new_password,
                :password_confirmation,
                :user

  validate :current_password_entered

  def update!
    raise ActiveRecord::RecordInvalid, self unless valid?

    @user = user

    ActiveRecord::Base.transaction do
      update_user!
    end

    self
  end

  private


  def update_user!
    @user.email = email.downcase if email
    @user.password = new_password if new_password
    @user.password_confirmation = password_confirmation if password_confirmation

    @user.save!
  end

  def current_password_entered
    raise CanCan::AccessDenied if !(@user.authenticate(current_password))
    return
  end
end
