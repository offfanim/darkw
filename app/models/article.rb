class Article < ApplicationRecord
  validates :body, presence: true

  def to_param
    custom_link
  end
end
