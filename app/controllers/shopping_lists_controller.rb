class ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = current_user.recipes.includes(:recipe_foods)
    @missing_foods = find_missing_foods
    @total_items = @missing_foods.sum(:quantity)
    @total_price = calculate_total_price(@missing_foods)
  end

  private

  def find_missing_foods
    current_user.foods
    # recipe_foods = RecipeFood.includes(:food).where(recipe: @recipes).group(:food_id)
    # recipe_foods.select { |rf| user_foods.find_by(id: rf.food_id).nil? }
  end

  def calculate_total_price(foods)
    foods.sum { |food| food.food.price * food.quantity }
  end
end
