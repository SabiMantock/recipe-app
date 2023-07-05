Rails.application.routes.draw do
    devise_for :users

      authenticated :user do
    root 'foods#index', as: :authenticated_root
    resources :foods, only: [:index, :new, :create]

    resources :recipes, only: [:index, :new, :create, :show, :destroy]

      end
root 'recipes#index'
end
