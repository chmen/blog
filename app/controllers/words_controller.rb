class WordsController < ApplicationController
  def index
    @article = Article.last
    @clean_text = TextCleaner.clean_text(@article.text)

    @language = TextCleaner.check_lenguage(@article.text)

    Word.train(@clean_text, @language, @article.status)

    @words = Word.all
  end
end
