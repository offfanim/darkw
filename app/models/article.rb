class Article < ApplicationRecord
  has_secure_password(validations: false)

  validates :body, presence: true

  def to_param
    custom_link
  end

end
