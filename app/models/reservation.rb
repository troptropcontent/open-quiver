class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :board
  has_many :reviews
end
