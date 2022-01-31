class ArticlesController < ApplicationController
  before_action :reset_session, only: [:show, :new]

  def show
    @article = Article.find(params[:custom_link])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
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
      flash.now[:error] = 'wrong password'
      render :show, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(session[:article_custom_link])
  end

  def update
    @article = Article.find(session[:article_custom_link])
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:body, :custom_link, :password)
  end

end
