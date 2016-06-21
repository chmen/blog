class Word < ActiveRecord::Base

  def self.mass_train(text, status, words)
    clean_words = TextCleaner.clean_text(text)
    language = TextCleaner.check_language(text)

    clean_words.each do |clean_word|
      Word.train(clean_word, language, status, words)
    end

  end

  def self.train(clean_word, language, status, words)
    word = Word.get_or_new(clean_word, language, words)

    if status == 2
      word.spam += 1
    elsif status == 1
      word.ham += 1
    end
    word.save
    word
  end

  def self.spam_probability_word(word)

    probability = word.spam.to_f / (word.spam.to_f + word.ham.to_f)
  end

  def self.spam_probability_text(words_probabilities)
    multiplication = 1
    multiplication_reverse = 1

    words_probabilities.each do |word_probability|
      multiplication *= word_probability
      multiplication_reverse *= (1 - word_probability)
    end

    probability = (multiplication/(multiplication + multiplication_reverse)).round(5)
  end

  def self.generate_list_of_exist_words(clean_words, language, words)
    exist_words = []

    #should be more gorgeous solution, than inserted loop
    clean_words.each do |clean_word|
      words.each do |word|
        if word.name == clean_word
          if word.language == language
            if word.ham + word.spam > 1
              exist_words.push(word)
            end
          end
        end
      end
    end

    exist_words
  end


  def self.analyze(text, words)
    clean_words = TextCleaner.clean_text(text)
    language = TextCleaner.check_language(text)

    #we use array only of word thet alredy exist
    exist_words = Word.generate_list_of_exist_words(clean_words, language, words)

    words_probabilities = []

    exist_words.each do |exist_word|
      words_probabilities.push(Word.spam_probability_word(exist_word))
    end

    text_probability =  Word.spam_probability_text(words_probabilities)

    status = 2

    if text_probability < 0.5
      status = 1
    elsif text_probability >= 0.5
      status = 2
    end

    status
  end

  def self.get_or_new(clean_word, language, words)
    word = Word.new

    words.each do |word|
      if word.name == clean_word
        if word.language == language
          return word
        end
      end
    end

    word.name = clean_word
    word.language = language
    word.spam = 0
    word.ham = 0
    word
  end

  def self.generate_accuracy(articles, words)
    number_of_experiments = 0
    positive_experiments = 0

    articles.each do |article|
      number_of_experiments += 1
      text = article.text

      experimental_status = Word.analyze(text, words)
      real_status = article.status

      if real_status == experimental_status
        positive_experiments += 1
      end
    end

    accuracy = positive_experiments.to_f / number_of_experiments.to_f * 100

  end

end
