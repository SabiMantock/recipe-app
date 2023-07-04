Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    root 'foods#index'

  resources :foods, only: [:index, :new, :create]


  # Defines the root path route ("/")
  # root "articles#index"
  devise_for :users
  root 'recipes#index'
  resources :recipes, only: [:index]
end
