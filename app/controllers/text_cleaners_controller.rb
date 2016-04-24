#require "article"

class TextCleanersController < ApplicationController



  def index
    @article = Article.last

    @clean_text = TextCleaner.clean_text(@article.text)

  end

  def new
    @textCleaner = TextCleaner.new
  end

end
