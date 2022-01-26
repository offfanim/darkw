class AddPasswordToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :password_digest, :string
  end
end
