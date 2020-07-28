require 'rails_helper'

RSpec.describe "sign in", type: :feature do
  before :each do
    User.create(name:'Juan' ,email: 'user@mail.com', password: 'password')
  end

  it "signs me in" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'Email', with: 'user@mail.com'
      fill_in 'Password', with: 'password'
    end
    click_button 'commit'
    visit users_path
    expect(page).to have_content 'Sign Out'
  end
end
