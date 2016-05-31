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
