class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  has_many :foods, dependent: :destroy
  accepts_nested_attributes_for :foods
  has_many :recipes, dependent: :destroy
  validates :name, presence: true
end
