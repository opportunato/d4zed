class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :require_login, :except => [:not_authenticated]

  def not_authenticated
    redirect_to main_app.login_path
  end
end
