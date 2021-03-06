Rails.application.routes.draw do
  get '/',
    to: 'articles#new',
    as: 'new_article'

  get '/:custom_link',
    to: 'articles#show',
    as: 'article'

  get '/:custom_link/edit',
    to: 'articles#edit',
    as: 'edit_article'

  post '/:custom_link/access_to_edit',
    to: 'articles#access_to_edit',
    as: 'access_to_edit_article'

  post '/articles',
    to: 'articles#create'

  match '/:custom_link',
    to: 'articles#update',
    via: [:patch, :put]

end
