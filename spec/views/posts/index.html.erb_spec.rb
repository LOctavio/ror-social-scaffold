require 'rails_helper'

RSpec.describe "Posts", type: :feature do
  before :each do
    User.create(name:'Juan' ,email: 'user@mail.com', password: 'password')
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'Email', with: 'user@mail.com'
      fill_in 'Password', with: 'password'
    end
    click_button 'Log in'
    visit posts_path
  end

  it "Users can create post" do
    within("#new_post") do
      fill_in 'post_content',with: 'new post'
    end
    click_button 'Post'
    expect(page).to have_content 'new post'
  end

  it "Users can like post" do
    Post.create(user_id: 1, content: 'First test post')
    first("li.post").click_link("Like")
    expect(page).to have_content 'Dislike'
  end

  it "Users can comment posts" do
    first("li.post").fill_in "comment_content", with: "test comment"
    first("li.post").click_button 'Comment'
  end
end
