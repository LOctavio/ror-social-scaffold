class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @friend_requests = Friendship.friend_requests_received(current_user.id)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
    @friends = @user.friends
  end

  def friend_requests
    @friend_requests = Friendship.friend_requests_received(current_user.id)
  end

  def pending_friends
    @pending_friends = current_user.pending_friends
  end
end
