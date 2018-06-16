Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help', to: 'static_pages#help'

  post '/newstaffmember', to: 'staff_members#create'
  get  '/newstaffmember', to: 'staff_members#new'
  resources :staffmembers, only: [:new, :create, :edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
