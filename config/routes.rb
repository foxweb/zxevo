Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_scope :user do
    get 'login',  to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
    get 'signup', to: 'devise/registrations#new'
  end

  get 'blog', to: 'posts#index'
  get 'rss',  to: 'posts#index', defaults: { format: :rss }

  resources :posts

  get '/:slug' => 'pages#show', as: :static, slug: /[a-z0-9_\/]+/

  root to: 'home#index', as: :homepage, via: :get
end
