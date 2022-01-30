class ArticlesController < ApplicationController
  before_action :reset_session, only: [:show, :new]

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
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def access_to_edit
    @article = Article.find(params[:custom_link])
    if @article.authenticate(params[:password])
      session[:article_custom_link] = @article.custom_link
      redirect_to edit_article_path
    else
      flash[:error] = 'wrong password'
      render :show, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(session[:article_custom_link])
  end

  def update
    @article = Article.find(session[:article_custom_link])
    if @article.update(article_params)
      clear_custom_link
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:body, :custom_link, :password)
  end

  # this method needs article.save BEFORE and AFTER
  def clear_custom_link
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
    @article.save
  end

end
