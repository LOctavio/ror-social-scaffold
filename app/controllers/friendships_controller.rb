class FriendshipsController < ApplicationController

    def index
        @friend_list = current_user.friendships.all
    end
    
    def create
        @friend = current_user.friendships.create(friendship_params)

        redirect_to root_path
    end

    private

    def friendship_params
        params.permit(:user_id, :friend_id, :status)
    end

end
