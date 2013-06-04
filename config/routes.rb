Zxevo::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  devise_scope :user do
    get 'login',  to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
    get 'signup', to: 'devise/registrations#new'
  end

  get 'blog', to: 'posts#index'
  resources :posts

  root to: 'home#index'
end
