class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  def follow
    current_user.follow(@user.id)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.turbo_stream
    end
  end

  def unfollow
    current_user.unfollow(@user.id)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.turbo_stream
    end
  end

  private

  def set_user
    @user = User.find_by(user_name: params[:user_name])
    unless @user
      redirect_to root_path, alert: "User not found." and return
    end
  end
end
