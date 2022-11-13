Riverboss::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  root 'rivers#home_page'

  # Static Pages
  get 'about' => 'pages#about'
  get 'advertise' => 'pages#advertise'
  get 'disclaimer' => 'pages#disclaimer'
  get 'methodology' => 'pages#methodology'

  get '/html_view' => 'mobile#switch_to_html'
  get '/mobile_view' => 'mobile#switch_to_mobile'

  # Admin Routes
  namespace :admin do
    resources :rivers, only: [:index, :edit, :update] do
      get :search, on: :collection
    end
    resources :users, only: [:index]
    resources :regions, only: [:index]
    resources :states, only: [:index]
  end

  resources :pages, except: [:destroy, :add, :create]

  get 'contact' => 'contacts#new', as: 'contact'
  post 'contact' => 'contacts#create', as: 'contact_submit'

  get 'suggest' => 'suggest#new', as: 'suggest'
  post 'suggest' => 'suggest#create', as: 'suggest_submit'

  resources :posts

  resources :rivers, only: [:index, :show] do
    get :autocomplete, on: :collection
    get :near_by, on: :collection
    get :search, on: :collection
    get :popular, on: :collection
    get :default_conditions, on: :collection
  end

  resources :regions, only: [:index, :show]
  resources :states, only: [:index, :show]

  resources :users_rivers, except: [:show] do
    post :sort, on: :collection
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", registrations: 'registrations' }, path: '', path_names: {sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'user', sign_up: 'signup'}, sign_out_via: [:get]
end
