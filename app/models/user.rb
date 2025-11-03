class User < ApplicationRecord
  validates :user_name, presence: true, uniqueness: true, length: {maximum: 30, minimum: 6}
  has_one_attached :profile_picture
  validate { errors.add(:profile_picture, "must be a valid image") if profile_picture.attached? && !profile_picture.content_type.in?(%w[image/png image/jpg image/jpeg image/webp]) }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :follower_relationships, class_name: "Follow", foreign_key: :following_id, dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :following_relationships, source: :following

  has_many :chat_users, dependent: :destroy
  has_many :chats, through: :chat_users
  has_many :messages, dependent: :destroy

  def follow(id)
    following_relationships.create(following_id: id)
  end

  def unfollow(id)
    following_relationships.find_by(following_id: id).destroy
  end

  def following?(user)
    following.include?(user)
  end
end
