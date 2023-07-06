class RecipesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_recipe_toggle, only: [:toggle]

  def index
    @recipes = if user_signed_in?
                 current_user.recipes.includes(:user)
               else
                 Recipe.where(public: true)
               end

    @recipes = @recipes.order(created_at: :desc)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_foods = @recipe.recipe_foods.includes(:food)
  end

  def new
    @recipe = current_user.recipes.build
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    @recipe.public = false

    if @recipe.save
      redirect_to recipes_path, notice: 'Recipe created successfully.'
    else
      render :new
    end
  end

  def toggle
    @recipe = Recipe.find(params[:id])
    @recipe.update(public: !@recipe.public)

    if @recipe.public?
      session[:public_recipes] ||= []
      session[:public_recipes] << @recipe.id
    elsif session[:public_recipes]
      session[:public_recipes].delete(@recipe.id)
    end

    respond_to do |format|
      format.html { redirect_to @recipe }
    end
  end

  def public_recipes
    @public_recipes = Recipe.where(public: true).order(created_at: :desc)
  end

  def destroy
    @recipe = current_user.recipes.find(params[:id])
    @recipe.destroy
    redirect_to recipes_path, notice: 'Recipe deleted successfully.'
  end

def shopping_list
  @recipes = current_user.recipes.includes(:recipe_foods)
  @missing_foods = find_missing_foods
@total_items = @missing_foods.pluck(:quantity).sum
  @total_price = calculate_total_price(@missing_foods)
end

  private

  def authorize_recipe_toggle
    @recipe = Recipe.find(params[:id])
    return if @recipe.user_id == current_user.id

    flash[:error] = 'You are not authorized to perform this action.'
    redirect_to recipes_path
  end

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :public, :description)
  end

def find_missing_foods
  missing_foods = []
  @recipes.each do |recipe|
    recipe.recipe_foods.each do |recipe_food|
      missing_quantity = recipe_food.quantity
      missing_foods << recipe_food if missing_quantity && missing_quantity > 0
    end
  end
  missing_foods
end

def calculate_total_price(missing_foods)
  total_price = 0
  missing_foods.each do |recipe_food|
    total_price += recipe_food.quantity * recipe_food.food.price
  end
  total_price
end
end
