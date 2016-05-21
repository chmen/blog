class WordsController < ApplicationController
  def index
    words = Word.all
    words.destroy_all

    #@article = Article.last
    articles = Article.all

    articles.each do |article|
      clean_text = TextCleaner.clean_text(article.text)
      language = TextCleaner.check_lenguage(article.text)
      Word.train(clean_text, language, article.status)
    end

    #@clean_text = TextCleaner.clean_text(@article.text)

    #@language = TextCleaner.check_lenguage(@article.text)

    #Word.train(@clean_text, @language, @article.status)

    @words = Word.all
  end
end
