Rails.application.routes.draw do

  root 'articles#new'

  get '/articles', to: 'articles#index'
  get '/:custom_link', to: 'articles#show', as: 'article'
  get '/', to: 'articles#new', as: 'new_article'
  get '/:custom_link/edit', to: 'articles#edit', as: 'edit_article'
  post '/articles', to: 'articles#create'
  match '/:custom_link', to: 'articles#update', via: [:patch, :put]
  delete '/:custom_link', to: 'articles#destroy'
end
