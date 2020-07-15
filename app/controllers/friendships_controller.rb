class FriendshipsController < ApplicationController

    def index
        @friend_list = current_user.friends
    end
    
    def create
        @friend = current_user.friendships.create(friendship_params)

        
        redirect_to root_path
    end

    def update
        @friend = Friendship.find_by(params[:friend_id])

        
    end

    def destroy

    end

    private

    def friendship_params
        params.permit(:user_id, :friend_id)
    end

end
