Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help', to: 'static_pages#help'

  get '/newstaffmembers', to: 'staff_members#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
