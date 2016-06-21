namespace :bayes do
  task :train => :environment do
    words = Word.all
    words.destroy_all
    articles = Article.all
    
    articles.each do |article|
      words = Word.all
      text = article.text
      status = article.status
      Word.mass_train(text, status, words)
    end

  end
end
