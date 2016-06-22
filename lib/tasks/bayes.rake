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

  task :generate_accuracy => :environment do
    articles = Article.all
    words = Word.all

    accuracy = Word.generate_accuracy(articles, words)

    puts "accuracy of naiv bayes classifier is #{accuracy} %" 
  end
end
