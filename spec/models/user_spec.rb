require 'rails_helper'

RSpec.describe User, type: :model do
  it "A user has many friends" do
    expect(User.reflect_on_association(:friends).macro).to eq(:has_many)
  end

  it "A user can write many posts" do
    expect(User.reflect_on_association(:posts).macro).to eq(:has_many)
  end

  it "A user can like many posts" do
    expect(User.reflect_on_association(:likes).macro).to eq(:has_many)
  end

  it "A user has many pending friends" do
    expect(User.reflect_on_association(:pending_friends).macro).to eq(:has_many)
  end

  it "A user has many friend requests" do
    expect(User.reflect_on_association(:friend_requests).macro).to eq(:has_many)
  end
end
