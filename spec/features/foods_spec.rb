require 'rails_helper'

RSpec.describe 'Foods Index', type: :feature do

  before(:each) do
    @user = User.create(email: 'saba@example.com', password: 'sabani', name: 'saba')
    @user.confirm
    @food = Food.create(name: 'Saba food', measurement_unit: 'test', price: 5, quantity: 2, user: @user)
    sign_in @user
    visit foods_path
  end

  it 'shows the header title' do
    expect(page).to have_content('Food List')
  end

  it 'shows the food details' do
    expect(page).to have_content(@food.name)
    expect(page).to have_content(@food.measurement_unit)
    expect(page).to have_content(@food.price)
    expect(page).to have_button('Delete')
  end
  it 'delete the food' do
    click_button 'Delete'
    expect(page).to have_current_path(foods_path)
    expect(page).not_to have_content(@food.name)
    expect(page).not_to have_content(@food.measurement_unit)
    expect(page).not_to have_content(@food.price)
    expect(page).not_to have_content(@food.quantity)
    expect(page).not_to have_button('Delete')
    expect(page).not_to have_button('Modify')
  end
end