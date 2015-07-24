class SessionsController < ApplicationController
  def index

  end

  def create
    user = User.find_by(email: params[:user][:email].downcase)
    if user && user.authenticate(params[:user][:password])
      log_in user
      redirect_to home_index_path
    else
      # flash.now[:danger] = 'Invalid email/password combination'
      @error = 'Invalid email/password combination'
      render 'index'
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
