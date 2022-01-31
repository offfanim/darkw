module ArticlesHelper

  def custom_link_without_id_for_form(custom_link)
    custom_link.blank? ? custom_link : custom_link.gsub(/\A\d+-?/, '')
  end

  def sanitized_article_body
    sanitize @article.body, tags: %w(p h1 h2 br em u s a pre img), attributes: %w(src href target)
  end
end
