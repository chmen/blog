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

    #should be more gorgeous solution, than inserted loop
    clean_words.each do |clean_word|
      words.each do |word|
        if word.name == clean_word
          exist_words.push(word)
        end
      end
    end

    exist_words
  end


  def self.analyze(text, words)
    clean_words = TextCleaner.clean_text(text)
    #we use array only of word thet alredy exist
    exist_words = Word.generate_list_of_exist_words(clean_words, words)

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
