class ArticlesController < ApplicationController

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find_by(custom_link: params[:custom_link])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      clear_custom_link
      @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:custom_link])
  end

  def update
    @article = Article.find(params[:custom_link])
    if @article.update(article_params)
      if params[:custom_link] != @article.custom_link
        clear_custom_link
        @article.save
      end
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find_by(custom_link: params[:custom_link])
    @article.destroy

    redirect_to new_article_path
  end

  private

  def article_params
    if params[:article][:body] =~ %r{\A(<p>[[:blank:]]*(<br>)?<\/p>)+\z}
      params[:article][:body] = ''
    end
    params.require(:article).permit(:body, :custom_link)
  end

  def clear_custom_link
    custom_link = @article.custom_link
    id = @article.id.to_s  # this metgod should be AFTER article.save

    if [nil, ''].include? custom_link
      @article.custom_link = id
    else
      new_custom_link = custom_link.gsub(/[ _]/, '-').delete('^A-Za-z0-9-')

      if new_custom_link == ''
        @article.custom_link = id
      else
        @article.custom_link = "#{id}-#{new_custom_link}"[0...100]
      end
    end
  end

end
