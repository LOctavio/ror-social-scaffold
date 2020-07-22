module UsersHelper
    def friend_request_button_handler(user)
        if user != current_user && !current_user.friend?(user)
            pending_friend = current_user.pending_friends.find { |friend| friend.id == user.id }
            friend_request = current_user.friend_requests.find { |friend| friend.id == user.id }

            if friend_request
                link_to("Friend request", requests_path, class: 'profile-link')
            elsif pending_friend
                button_to('Pending', user_path(user), disabled: true)
            else
                button_to("Add friend", send_friendship_request_path(user_id: user.id))
            end
        end
    end

    def users_list
        user_list_html = ''
        @users.each do |user|
            user_list_html += <<-HTML
            <li>
                #{link_to user.name,  user_path(user), class: 'profile-link'}
                #{friend_request_button_handler(user)}
            </li>
            HTML
        end
        user_list_html.html_safe
    end

    def friendship_confirmation_buttons
        friendship_html = ''

        @friend_requests.each do |fr|
            friendship_html += <<-HTML
            #{link_to fr.name, user_path(fr.user_id), class: 'profile-link'}
            #{ button_to "Confirm", update_friendship_path({friendship: fr, status: true}), method: 'patch'}
            #{ button_to "Delete request", delete_request_path(friendship: fr), method: 'delete'}
            HTML
        end

        friendship_html.html_safe
    end
end