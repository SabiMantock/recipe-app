class RecipesController < ApplicationController
  def index
    @recipes = if user_signed_in?
                 current_user.recipes
               else
                 Recipe.where(public: true)
               end

    @recipes = @recipes.order(created_at: :desc)
  end
end
