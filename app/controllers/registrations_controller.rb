class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end
  def create
    super
  end
  def update
    super
  end
  def sign_up_params
     params.require(:user).permit(:email, :password, :password_confirmation, :name, :invite_code, :signup_account_type)
  end
  def account_update_params
     params.require(:user).permit(:name, :email, :current_password, :password, :password_confirmation)
  end
end
