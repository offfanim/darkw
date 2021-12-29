Rails.application.routes.draw do

  root 'articles#new'

  get '/articles', to: 'articles#index'
  get '/:custom_link', to: 'articles#show', as: 'article'
  get '/', to: 'articles#new'
  get '/:custom_link/edit', to: 'articles#edit'
  post '/articles', to: 'articles#create'
  patch '/:custom_link', to: 'articles#update'
  put '/:custom_link', to: 'articles#update'
  delete '/:custom_link', to: 'articles#destroy'
end
