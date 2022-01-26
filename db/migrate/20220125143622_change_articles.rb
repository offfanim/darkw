class ChangeArticles < ActiveRecord::Migration[7.0]
  def change
    change_column_null :articles, :body, false
    change_column_null :articles, :custom_link, false
    add_index :articles, :custom_link, unique: true
  end
end
