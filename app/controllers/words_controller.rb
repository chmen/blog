class WordsController < ApplicationController

def index

  articles = Article.all
  words = Word.all

  @accuracy = Word.generate_accuracy(articles, words)

  @words = Word.all  
end



=begin  
  def index
    words = Word.all
    words.destroy_all

    articles = Article.all

    #Word.train(["one", "two"], "rus", 1)
    #Word.train(["two", "four"], "rus", 2)
    articles.each do |article|
      clean_text = TextCleaner.clean_text(article.text)
      language = TextCleaner.check_lenguage(article.text)
      status = article.status

      Word.train(clean_text, language, status)
    end

    @words = Word.all
  end
=end
end
