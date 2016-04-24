#require "article"

class TextCleanersController < ApplicationController



  def index
    @article = Article.last

    @splitText = TextCleaner.check_lenguage(@article.text)

  end

  def new
    @textCleaner = TextCleaner.new
  end

end
