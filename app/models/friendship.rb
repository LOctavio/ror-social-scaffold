class Friendship < ApplicationRecord
    belongs_to :user
    belongs_to :friend, class_name: 'User'

    validates_uniqueness_of :user_id, scope: :friend_id

    def self.friend_requests_received(current_user)
        find_by_sql(["SELECT * FROM users u JOIN friendships f ON u.id = f.user_id
            WHERE f.status = false AND f.friend_id = ?", current_user])
    end

    def confirm_friend
        self.update_attributes(status: true)
        Friendship.create!(friend_id: self.user_id , user_id: self.friend_id, status: true)
    end                  
end
