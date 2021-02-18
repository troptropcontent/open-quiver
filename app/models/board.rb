class Board < ApplicationRecord

  CATEGORY = ["all","shortboard", "hybride", "longboard", "fish", "egg", "enfant", "stand up paddle", "mini malibu", "évolutive", "gun", "foil", "planche en mousse", "mid-length", "évolutive / hybride", "deco", "vintage", "retro"]
  # GEOVODER SET UP
  geocoded_by :full_address
  after_validation :geocode, if: :will_save_change_to_zipcode? && :will_save_change_to_street? && :will_save_change_to_city? && :will_save_change_to_country?

  has_one_attached :photo
  belongs_to :user
  validates :category, :inclusion=> { in: CATEGORIES}
  has_many :reservations
  has_many :reviews, through: :reservations

  scope :active, -> { where("status = ?", "active") }
  scope :category, ->(cat) { where("category = ?", cat) }


  def full_address
    "#{street}, #{zipcode}, #{city}, #{country}"
  end
  
end

