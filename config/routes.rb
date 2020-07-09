Rails.application.routes.draw do
  resources :accounts, defaults: {format: :json}
  resources :transfers, defaults: {format: :json}
end
