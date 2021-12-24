class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.text :body
      t.string :custom_link

      t.timestamps
    end
  end
end
