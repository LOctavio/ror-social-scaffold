class FriendshipsController < ApplicationController

    def index
      @friend_list = current_user.friends
    end

    def create
      @friend = current_user.friendships.build(friend_id: params[:user_id])
      
      if @friend.save
        redirect_back(fallback_location: root_path, notice: 'Friendship request was sent.')
      else
        redirect_back(fallback_location: users_path)
      end
    end

    def update
      @friendship = Friendship.find(params[:friendship])

        return unless @friendship.update(friendship_params)

        flash[:notice] = 'Friend request accepted.'
        redirect_to requests_path
    end

    def destroy
      @friendship = Friendship.find(params[:friendship])
          
      return unless @friendship.destroy

      redirect_to requests_path
    end

    private

    def friendship_params
        params.permit(:status)
    end

end
