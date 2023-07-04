Rails.application.routes.draw do
    devise_for :users

      authenticated :user do
    root 'foods#index', as: :authenticated_root
    resources :foods, only: [:index, :new, :create]
      end
    root 'recipes#index'
  resources :recipes, only: [:index]
end
