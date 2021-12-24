class Article < ApplicationRecord
  validates :body, presence: true
end
