class Word < ActiveRecord::Base

  def self.train(clean_words, language, status)

    clean_words.each do |clean_word|
      # first, lets check if the word already exist
      if Word.exists?(:name => clean_word, :language => language)
        word = Word.where(name: clean_word, :language => language).take
        if status == 2
          word.ham += 1

        elsif status == 1
          word.spam += 1
        end
      else
        word = Word.new
        word.name = clean_word
        word.language = language
        if status == 2
          word.ham = 1
          word.spam = 0
        elsif status == 1
          word.spam = 1
          word.ham = 0
        end
      end
      word.save
    end

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

  def self.generate_list_of_exist_words(clean_words, words)
    exist_words = []
    

    clean_words.each do |clean_word|
      if words.include?(clean_word)
        exist_words.push(clean_word)
      end
    end

    exist_words
  end

  def self.analyze(text)
    clean_words = TextCleaner.clean_text(text)

    #we use array only of word alredy exist

    exist_words =


      words_probabilities = []

    clean_words.each do |clean_word|
      words_probabilities.add(Word.spam_probability_word(clean_word))
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

  # Person.exists?(name: 'David')

  #def self.get_or_new(word, language)

  #  record = Word.where(name: word)
  #  if  record.instance_variable_defined?
  #      record.name = word
  #    record.language = language
  #    end
  #    ecord = BayesWord.new
  #  end
  #end


  #def self.train(clean_words, language, spam)
  #  clean_words.each do |word|
  #    get_or_new(word)
  #
  #    if spam = true
  #      bayesWord.spam += 1
  #    end
  #    if spam = false
  #      bayesWord.ham += 1
  #    end

  #  end
  #end

end
