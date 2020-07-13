class FriendshipsController < ApplicationController

    def index
        @friend_list = current_user.friendships.all
    end
    
    def create
        @friend = Friendship.create(friendship_params)

        redirect_to root_path
    end

    private

    def friendship_params
        params.permit(:user_id, :friend_id)
    end

end
