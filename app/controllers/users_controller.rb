class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @invites = Friendship.friend_requests_received(current_user.id)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end

  def friend_requests
    @friend_requests = Friendship.friend_requests_received(current_user.id)
  end
end
