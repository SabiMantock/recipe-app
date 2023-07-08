require 'rails_helper'

RSpec.describe 'Shopping list index', type: :feature do
  before(:each) do
    @user = User.create(email: 'saba@example.com', password: 'sabani', name: 'saba')
    @user.confirm
    sign_in @user
    @food = Food.create(name: 'My food', measurement_unit: 'test', price: 10, quantity: 10, user: @user)
    @recipe = Recipe.create(name: 'My recipe', preparation_time: 10, cooking_time: 10, description: 'My description',
                            public: true, user: @user)
    @recipe_foods = @recipe.recipe_foods.create(food_id: @food.id, quantity: 12, recipe_id: @recipe.id)
    visit shopping_list_path
  end

  it 'shows the header title' do
    expect(page).to have_content('Shopping List')
  end
  it 'shows the food details' do
    expect(page).to have_content(@food.name)
    expect(page).to have_content(@recipe_foods.quantity - @food.quantity)
    expect(page).to have_content((@recipe_foods.quantity - @food.quantity) * @food.price)
  end
end
