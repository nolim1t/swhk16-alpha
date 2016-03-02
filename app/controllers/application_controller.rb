class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def set_locale
    autoset_lang = 'en'
    begin
      autoset_lang = request.headers['Accept-language'].split(',')[0]
    rescue
      puts "Can't autoset language for #{request.headers['Accept-language']}"
    end
    # Only if its supported
    if autoset_lang.include? "en" or autoset_lang.include? "zh" then
      if autoset_lang.include? "en" then
        autoset_lang = "en"
      end
      if autoset_lang.include? "zh" then
        autoset_lang = "zh"
      end
    end
    I18n.locale = autoset_lang || params[:locale] || I18n.default_locale
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name, :accounttype, :invite_code) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :current_password, :password, :password_confirmation, :accounttype) }
  end
end
