class Board < ApplicationRecord
  CATEGORIES = ["shortboard", "hybride", "longboard", "fish", "egg", "enfant", "stand up paddle", "mini malibu", "évolutive", "gun", "foil", "planche en mousse", "mid-length", "évolutive / hybride", "deco", "vintage", "retro"]
  has_one_attached :photo
  belongs_to :user
  validates :category, :inclusion=> { in: CATEGORIES}
  has_many :reservations

  scope :active, -> { where("status = ?", "active") }
  scope :category, ->(cat) { where("category = ?", cat) }
end

