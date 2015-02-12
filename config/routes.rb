Rails.application.routes.draw do
  namespace :api do
    resources :time_stocks
  end
end
