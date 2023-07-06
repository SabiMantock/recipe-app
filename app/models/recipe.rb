class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_foods, dependent: :destroy
  has_many :foods, through: :recipe_foods, dependent: :destroy

  validates :name, presence: true
  validates :preparation_time, presence: true, numericality: { greater_than: 0 }
  validates :cooking_time, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :user_id, presence: true

  def calculate_total_amount
    total_amount = 0
    recipe_foods.each do |recipe_food|
      total_amount += recipe_food.food.price * recipe_food.quantity
    end
    total_amount
  end

  scope :public_recipes, -> { where(public: true) }

  def public?
    public
  end
end
