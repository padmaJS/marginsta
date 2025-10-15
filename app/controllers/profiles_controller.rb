class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :authorize_owner, except: [:show]

  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to profile_path(params[:user_name]), info: "Profile updated successfully"
    else
      redirect_to profile_path(params[:user_name]), alert: "Something went wrong"
    end
  end

  private

  def set_user
    @user = User.find_by(user_name: params[:user_name])
    unless @user
      redirect_to root_path, alert: "User not found." and return
    end
  end

  def authorize_owner
    redirect_to profile_path(params[:user_name]), alert: "Cannot edit others profile" and return unless @user == current_user
  end

  def profile_params
    params.require(:user).permit([:bio, :profile_picture])
  end
end
