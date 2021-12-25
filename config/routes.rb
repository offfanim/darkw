Rails.application.routes.draw do

  root "articles#new"

  get "/articles", to: "articles#index"
  get "/:id", to: "articles#show", as: "article"
  get "/", to: "articles#new"
  get "/:id/edit", to: "articles#edit"
  post "/articles", to: "articles#create"
  patch "/:id", to: "articles#update"
  put "/:id", to: "articles#update"
  delete "/:id", to: "articles#destroy"
end
