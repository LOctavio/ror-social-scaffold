module UsersHelper
    def friend_request_button_handler(user)
        if user != current_user && !current_user.friend?(user)
            pending_friend = current_user.pending_friends.find { |friend| friend.id == user.id }
            friend_request = current_user.friend_requests.find { |friend| friend.id == user.id }

            if friend_request
                link_to('Friend request', requests_path, class: "friend-request-btn")
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
            <div class="user-preview-card">
                <div class="avatar avatar-lg">
                    <div class="avatar-image-wrapper">
                        #{image_tag(user.profile_image_path, class: "avatar-image", alt: user.name)}
                    </div>

                    <div class="avatar-content">
                        <div class="avatar-name">
                            <strong>#{link_to(user.name, user_path(user))}</strong>
                        </div>
                        <div class="avatar-friend-count">
                            #{pluralize(user.friends.count, 'friend')}
                        </div>
                    </div>
                </div>
                <div class="friendship-buttons">
                    #{friend_request_button_handler(user)}
                </div>
            </div>
            HTML
        end
        user_list_html.html_safe
    end

    def friendship_confirmation_buttons
        friendship_html = ''

        @friend_requests.each do |fr|
            friendship_html += <<-HTML
            <div class="user-preview-card">
                <div class="avatar avatar-lg">
                    <div class="avatar-image-wrapper">
                        #{image_tag(fr.user.profile_image_path, class: "avatar-image", alt: fr.name)}
                    </div>

                    <div class="avatar-content">
                        <div class="avatar-name">
                            #{link_to(fr.name, fr.user)}
                        </div>
                        <div class="avatar-friend-count">
                            #{pluralize(fr.user.friends.count, 'friend')}
                        </div>
                    </div>
                </div>
                <div class="friendship-buttons">
                    #{ button_to "Confirm", update_friendship_path({friendship: fr, status: true}), method: 'patch'}
                    #{ button_to "Delete request", delete_request_path(friendship: fr), method: 'delete', class: 'delete-fr-btn'}
                </div>
            </div>            
            HTML
        end

        friendship_html.html_safe
    end
end