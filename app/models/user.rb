class User < ApplicationRecord
  validates :user_name, presence: true, uniqueness: true, length: {maximum: 30, minimum: 6}
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
end
