Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root 'foods#index', as: :authenticated_root
    resources :foods, only: [:index, :new, :create, :destroy]
    resources :recipes, only: [:index, :new, :create, :show, :destroy] do
      member do
        patch 'toggle'
        get 'shopping_list'
      end
      resources :foods, only: [:new, :create]
      resources :recipe_foods, only: [:new, :create, :destroy]
    end

    get 'public_recipes', to: 'recipes#public_recipes', as: :public_recipes
    get 'shopping_list', to: 'recipes#shopping_list'
  end

  root 'recipes#index'
end
