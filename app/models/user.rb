class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_one_attached :profile_image
  has_one_attached :cover_image

  has_many :confirmed_friendships, -> { where status: true }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  has_many :pending_friendships, -> { where status: false }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

  has_many :inverted_friendships, -> { where status: false }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friend_requests, through: :inverted_friendships

  def friends
    friends_array = confirmed_friendships.map{|friendship| friendship.friend if friendship.status}
    friends_array.compact
  end

  def friend?(user)
    friends.include?(user)
  end

  def pending_friends
    pending_friendships.map{|friendship| friendship.friend if !friendship.status}.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverted_friendships.map{|friendship| friendship.user if !friendship.status}.compact
  end

  def reject_friend(user)
    friendship = inverse_friendships.find{ |f| f.user == user }
    friendship.status = false
    friendship.destroy
  end

  def profile_image_path
    profile_image.attached? ? profile_image : 'default-user.jpg'
  end

  def cover_image_path
    cover_image.attached? ? cover_image : nil
  end

  
  def friends_and_own_posts
    posts = Post.where("user_id IN (?) OR user_id = ? ", self.friends, self).order('created_at DESC')
  end
end