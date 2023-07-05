class RecipesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @recipes = if user_signed_in?
                 current_user.recipes
               else
                 Recipe.where(public: true)
               end

    @recipes = @recipes.order(created_at: :desc)
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = current_user.recipes.build
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    puts recipe_params
    if @recipe.save
      redirect_to recipes_path, notice: 'Recipe created successfully.'
    else
      render :new
    end
  end

  def destroy
    @recipe = current_user.recipes.find(params[:id])
    @recipe.destroy
    redirect_to recipes_path, notice: 'Recipe deleted successfully.'
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :public, :description)
  end
end
