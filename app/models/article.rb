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

  validates :password,
    length: { maximum: 100 }

  after_save :clear_custom_link_current_article

  def to_param
    custom_link
  end

  private

  # this method needs id, therefore it needs article.save before
  def clear_custom_link_current_article
    custom_link = self.custom_link
    id = self.id.to_s

    if custom_link.blank?
      self.custom_link = id
    else
      new_custom_link = custom_link.gsub(/[ _]/, '-').delete('^A-Za-z0-9-')

      if new_custom_link.blank?
        self.custom_link = id
      else
        self.custom_link = "#{id}-#{new_custom_link}"[0...100]
      end
    end
    Article.skip_callback :save, :after, :clear_custom_link_current_article
    self.save
    Article.set_callback :save, :after, :clear_custom_link_current_article
  end

end
