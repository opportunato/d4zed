class UserSessionsController < ApplicationController
  skip_before_filter :require_login

  layout 'login'
  
  def new
    @user = User.new
  end
  
  def create
    respond_to do |format|
      if @user = login(params[:username], params[:password])
        format.html { redirect_back_or_to(rails_admin.dashboard_path) }
      else
        format.html { render action: "new" }
      end
    end
  end
end