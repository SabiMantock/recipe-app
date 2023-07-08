require 'rails_helper'

RSpec.describe 'Recipes index', type: :feature do
  before(:each) do
    @user = User.create(email: 'user@example.com', password: 'password', name: 'user')
    @user.confirm
    @recipe = Recipe.create(name: 'My recipe', preparation_time: 10, cooking_time: 10, description: 'test',
                            public: false, user: @user)
    @food = Food.create(name: 'My food', measurement_unit: 'test', price: 10, quantity: 10, user: @user)
    sign_in @user
    visit recipes_path
  end
  it 'shows the header title' do
    expect(page).to have_content('Recipes')
  end

  it 'shows the recipe name' do
    expect(page).to have_content(@recipe.name)
  end

  it 'shows the recipe description' do
    expect(page).to have_content(@recipe.description)
  end

  it 'shows and visits the link to the recipe show page' do
    expect(page).to have_link(@recipe.name)
    click_link @recipe.name
    expect(page).to have_current_path(recipe_path(@recipe))
  end

  it 'shows and visits the link to the add recipe page' do
    expect(page).to have_link('Create New Recipe')
    click_link 'Create New Recipe'
    expect(page).to have_current_path(new_recipe_path)
  end
end

RSpec.describe 'recipes visit index and delete recipe', type: :feature do
  before(:each) do
    @user = User.create(email: 'user@example.com', password: 'password', name: 'user')
    @user.confirm
    @recipe = Recipe.create(name: 'My recipe', preparation_time: 10, cooking_time: 10, description: 'test',
                            public: false, user: @user)
    @food = Food.create(name: 'My food', measurement_unit: 'test', price: 10, quantity: 10, user: @user)
    sign_in @user
    visit recipes_path
  end
  context 'when deleting a recipe' do
    it 'shows the button to delete the recipe' do
      expect(page).to have_button('Delete Recipe')
    end

    it 'deletes the recipe when the delete button is clicked' do
      click_button 'Delete Recipe'
      expect(page).to have_current_path(recipes_path)
      expect(page).to have_content('No recipes found')
      expect(page).not_to have_content(@recipe.name)
      expect(page).not_to have_content(@recipe.description)
      expect(page).not_to have_link(@recipe.name)
      expect(page).not_to have_button('Delete Recipe')
    end
  end
end

RSpec.describe 'recipes visit show recipe ', type: :feature do
  before(:each) do
    @user = User.create(email: 'user@example.com', password: 'password', name: 'user')
    @user.confirm
    @recipe = Recipe.create(name: 'My recipe', preparation_time: 7, cooking_time: 10, description: 'test',
                            public: false, user: @user)
    @food = Food.create(name: 'My food', measurement_unit: 'test', price: 3, user: @user)
    @recipe_food = @recipe.recipe_foods.create(quantity: 5, food: @food)
    sign_in @user
    visit recipe_path(@recipe)
  end

  it 'shows the recipe details' do
    expect(page).to have_content(@recipe.name)
    expect(page).to have_content(@recipe.description)
    expect(page).to have_content(@recipe.preparation_time)
    expect(page).to have_content(@recipe.cooking_time)
  end

  it 'shows the button to generate shopping list and add ingredient' do
    expect(page).to have_link('Generate Shopping List')
    expect(page).to have_link('Add Ingredient')
  end

  it 'shows the ingredient list details' do
    expect(page).to have_content(@food.name)
    expect(page).to have_content("#{@recipe_food.quantity} #{@food.measurement_unit}")
    expect(page).to have_content(" $#{@food.price * @recipe_food.quantity}")
    expect(page).to have_link('Modify')
    expect(page).to have_button('Remove')
  end
end

RSpec.describe 'recipes visit show recipe', type: :feature do
  before(:each) do
    @user = User.create(email: 'user@example.com', password: 'password', name: 'user')
    @user.confirm
    @recipe = Recipe.create(name: 'My recipe', preparation_time: 7, cooking_time: 10, description: 'test',
                            public: false, user: @user)
    sign_in @user
    visit recipe_path(@recipe)
  end

  it 'toggles the recipe between public and private' do
    expect(page).to have_button('Private')

    click_button 'Private'
    expect(page).to have_current_path(recipe_path(@recipe))
    expect(page).to have_button('Public')

    click_button 'Public'
    expect(page).to have_current_path(recipe_path(@recipe))
    expect(page).to have_button('Private')
  end
end
