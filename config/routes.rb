Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :accounts, defaults: {format: :json}
  resources :transfers, defaults: {format: :json}
end
