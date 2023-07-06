require 'rails_helper'

RSpec.describe 'Public Recipes Index', type: :feature do

  before(:each) do
    @user1 = User.create(email: 'saba@example.com', password: 'sabani', name: 'saba')
    @user1.confirm
    sign_in @user1
    @user2 = User.create(email: 'saba2@example.com', password: 'sabani', name: 'sebenza')
    @user3 = User.create(email: 'user3@example.com', password: 'sabani', name: 'user3')
    @recipe1 = Recipe.create(name: 'My first recipe', preparation_time: 10, cooking_time: 10, description: 'test',
                             public: false, user: @user3)
    @recipe2 = Recipe.create(name: 'My second recipe', preparation_time: 10, cooking_time: 10, description: 'test',
                             public: true, user: @user2)
    @recipe3 = Recipe.create(name: 'My third recipe', preparation_time: 10, cooking_time: 10, description: 'test',
                             public: true, user: @user1)
    visit public_recipes_path
  end

  it 'shows the header title' do
    expect(page).to have_content('Public Recipes')
  end

  it 'shows details for recipe_2 and recipe_3 and not for recipe_1' do
    expect(page).to have_content(@recipe2.name)
    expect(page).to have_content(@recipe3.name)
    expect(page).not_to have_content(@recipe1.name)
    expect(page).to have_content("Author: #{@user1.name}")
    expect(page).to have_content("Author: #{@user2.name}")
    expect(page).to_not have_content("Author: #{@user3.name}")
  end
end