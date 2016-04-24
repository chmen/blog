class Word < ActiveRecord::Base

  def self.train(clean_words, language, spam)
    clean_words.each do |word|
      get_or_new(word)

      if spam = true
        bayesWord.spam += 1
      end
      if spam = false
        bayesWord.ham += 1
      end

    end
  end
end
