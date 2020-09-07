Rails.application.routes.draw do
  resources :offers
  post '/offers/toggle/:id', to: 'offers#toggle_status', as: 'toggle_status'
end
