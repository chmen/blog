class ArticlesController < ApplicationController
  #Standart orders of methods in Rails controller:
  #index
  #show
  #new
  #edit
  #create
  #update
  #destory
  http_basic_authenticate_with name: "dhh", password: "secret",
  except: [:index, :show]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id]) #we use @, because rails send all instance variable to the view
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end


  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render 'new' #render method passed @article method back to the new template
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end

  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end


  private
  def article_params
    params.require(:article).permit(:title, :text)
  end

end
