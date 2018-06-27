Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help', to: 'static_pages#help'

  post '/newstaffmember', to: 'staff_members#create'
  get  '/newstaffmember', to: 'staff_members#new'
  get  '/staffmembers/',  to: 'staff_members#index'

  get    '/signin',  to: 'sessions#new'
  post   '/signin',  to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  resources :staff_members, only: [:new, :create, :edit, :update, :destroy]
  resources :sessions,      only: [:new, :create, :destroy]
  resources :statuses,      only: [:new, :create, :edit, :update, :destroy]
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
