Rails.application.routes.draw do
  devise_for :users
  root "pages#home"
  get "my_portfolio", to: "users#my_portfolio"
end
