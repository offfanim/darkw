class Article < ApplicationRecord
  has_secure_password(validations: false)

  validates :body,
    presence: true,
    length: { maximum: 15_000_000, message: "is too long (maximum is 15000000 characters, ~10mb)" }

  validates :body,
    format: { without: %r{\A(<p>[[:blank:]]*(<br>)?<\/p>)+\z}, message: "can't be blank" },
    on: :create

  validates :custom_link,
    length: { maximum: 100 }

  def to_param
    custom_link
  end

end
