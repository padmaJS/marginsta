class Post < ApplicationRecord
  has_one_attached :image
  validate { errors.add(:image, "must be attached and be a valid image") unless image.attached? && image.content_type.in?(%w[image/png image/jpg image/jpeg image/gif image/webp]) }
  validates :user_id, presence: true
  validates :caption, length: {maximum: 300, minimum: 3}

  belongs_to :user
  has_many :comments, dependent: :destroy
end
