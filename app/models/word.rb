class Word < ActiveRecord::Base

  def self.train(clean_words, language, status)

    clean_words.each do |word|
    # first, lets check if the word already exist
      if Word.exists?(name: word)
        @word = Word.where(name: word)
        if status = 1
          @word.ham +=1
        elsif status = 2
          @word.spam +=1
        end

      else
        @word = Word.new
        @word.name = word
        @word.language = language
        if status = 1
          @word.ham = 1
        elsif status = 2
          @word.spam =1
        end

      end
    end
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
