class User < ApplicationRecord
  has_many_attached :photos
  #Watch out for the form !
  has_many :reservations
  has_many :boards
  has_many :reviews
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
