class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :friends, through: :friendships #class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  def friends
    friends_array = friendships.map{|friendship| friendship.friend if friendship.status}
    # friends_array + inverse_friendships.map{|friendship| friendship.user if friendship.status}
    friends_array.compact
  end

  def confirm_friend(user_id)
    friendship = inverse_friendships.find{|friendship| friendship.user_id == user_id && friendship.status = false}
    friendship.update_attribute(:status, true)
  end

  def friend?(user)
    friends.include?(user)
  end

  def pending_friends
    friendships.map{|friendship| friendship.friend if !friendship.status}.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map{|friendship| friendship.user if !friendship.status}.compact
  end

  def reject_friend(user)
    friendship = inverse_friendships.find{ |f| f.user == user }
    friendship.status = false
    friendship.destroy
  end
end
