Rails.application.routes.draw do
  resources :offers
  post '/offers/toggle/:id', to: 'offers#toggle_status', as: 'toggle_status'
  get '/offers/dashboard', to: 'offers#dashboard', as: 'dashboard'

  root 'offers#dashboard'
end
