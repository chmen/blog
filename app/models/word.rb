class Word < ActiveRecord::Base

  def self.mass_train(text, status)
    clean_words = TextCleaner.clean_text(text)
    language = TextCleaner.check_language(text)

    clean_words.each do |clean_word|
      Word.train(clean_word, language, status)
    end

  end

  def self.train(clean_word, language, status)
    word = Word.get_or_new(clean_word, language)

    if status == 2
      word.spam += 1
    elsif status == 1
      word.ham += 1
    end
    word.save(:validate => false)
    word
  end

  def self.spam_probability_word(word, train_session)
    #P(S|W) = P(W|S)/(P(W|S) + P(W|H)) 
    #P(W|S) = word.spam / quantity of spam texts
    probability_word_spam = 0
    probability_word_ham = 0

    if word.language == "rus"
      amount_spam_text = train_session.rus_spam
      amount_ham_text = train_session.rus_ham
    elsif word.language == "ukr"
      amount_spam_text = train_session.ukr_spam
      amount_ham_text = train_session.ukr_ham
    end	

    probability_word_spam = word.spam.to_f / amount_spam_text.to_f
    probability_word_ham = word.ham.to_f / amount_ham_text.to_f
    
    probability = probability_word_spam / (probability_word_spam + probability_word_ham)
  end

  def self.spam_probability_text(words_probabilities)
    words_probabilities = words_probabilities.first(20)

    multiplication = BigDecimal.new("1.0")
    
    multiplication_reverse = BigDecimal.new("1.0")

    words_probabilities.each do |word_probability|
      multiplication *= word_probability
      multiplication_reverse *= (1.0 - word_probability)
    end
    
    probability = BigDecimal.new("0")
    probability = (multiplication/(multiplication + multiplication_reverse))
  end

  def self.remove_100_percent_probabilitys(words_probabilities)
    words_probabilities.delete(1.0)
    words_probabilities
  end

  def self.generate_list_of_exist_words(clean_words, language)
    exist_words = []
    
    clean_words.each do |clean_word|
      if Word.exists?(:name => clean_word, :language => language)
        word = Word.where(name: clean_word, language: language).take
        if word.ham + word.spam > 1
          exist_words.push(word)
        end
      end
    end

    exist_words
  end


  def self.analyze(feed, train_session)
    #here we should check of sammery not empty 
    
    text = feed.title + feed.summary

    clean_words = TextCleaner.clean_text(text)
    language = TextCleaner.check_language(text)

    #we use array only of words thet alredy exist
    exist_words = Word.generate_list_of_exist_words(clean_words, language)

    words_probabilities = []

    exist_words.each do |exist_word|
      words_probabilities.push(Word.spam_probability_word(exist_word, train_session))
    end

    cut_words_probabilities = Word.remove_100_percent_probabilitys(words_probabilities)

    text_probability =  Word.spam_probability_text(cut_words_probabilities)

    status = Word.generate_status(text_probability)
  end

  def self.get_or_new(clean_word, language)
    
    word = Word.where(name: clean_word, language: language).take
    
    #Person.exists?(:name => "David")
    if word != nil
      return word
    end
    
    word = Word.new
    word.name = clean_word
    word.language = language
    word.spam = 0
    word.ham = 0
    word
  end

  def self.generate_status(text_probability)
    status = 0
    
    if text_probability <= 0.5
      status = 1
    elsif text_probability >= 0.95
      status = 2
    #If text unceratin, keep the status 0
    elsif text_probability > 0.5 && text_probability < 0.95
      status = 0
    end
    
    status
  end

end

