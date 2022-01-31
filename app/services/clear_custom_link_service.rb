class ClearCustomLinkService < ApplicationService

  def initialize(custom_link)
    @article = Article.find_by_custom_link(custom_link)
  end

  # this method needs id, therefore it needs article.save before
  def call
    custom_link = @article.custom_link
    id = @article.id.to_s

    if custom_link.blank?
      @article.custom_link = id
    else
      new_custom_link = custom_link.gsub(/[ _]/, '-').delete('^A-Za-z0-9-')

      if new_custom_link.blank?
        @article.custom_link = id
      else
        @article.custom_link = "#{id}-#{new_custom_link}"[0...100]
      end
    end
    return @article.custom_link if @article.save
  end

end
