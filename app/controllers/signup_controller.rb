class SignupController < ApplicationController
  def index

  end

  def create
    @user = User.new(user_params)
    @profile = @user.build_profile(profile_params)
    if @profile.save
      if @user.save
        log_in @user
        redirect_to home_index_path
      else
        p @user.errors
        render 'index'
      end
    else
      p @profile.errors
      render 'index'
    end

  end

  private
    def user_params
      params.require(:user).permit(:name ,:email, :password, :password_confirmation)
    end
    def profile_params
      params.require(:user).permit(:avatar)
    end
end
