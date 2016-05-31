require 'spec_helper'

describe Word, "#spam_probability_word" do 

  word2 = Word.new
  word2.name = 'реактор'
  word2.spam = 2
  word2.ham = 9

  word3 = Word.new
  word3.name = 'ДТП'
  word3.spam = 9
  word3.ham = 1

  context "with spam word" do
    it "returns probability more then 0.5" do
      expect(Word.spam_probability_word(word3)).to be > 0.5
    end
  end

  context "with ham word" do
    it "returns probability less then 0.5" do
      expect(Word.spam_probability_word(word2)).to be < 0.5
    end 
	end

end

describe Word, "#spam_probability_text" do
  words_spam_probabilities = [0.67, 0.9 , 0.85, 0.1, 0.7 ]
  words_ham_probabilities = [0.3 , 0.34, 0.5, 0.2 , 0.7, 0.2]
  contrlo_array = [0.2, 0.8, 0.5]


  context "with array with supremacy of spam probabilities" do
    it "return probability more then 0.5" do
      expect(Word.spam_probability_text(words_spam_probabilities)).to be > 0.5 
    end
  end

  context "with array with supremacy of ham probabilities" do
    it "return probability less then 0.5" do
      expect(Word.spam_probability_text(words_ham_probabilities)).to be < 0.5
    end
  end

  context "with control array" do 
    it "returns probability 0.5" do
      expect(Word.spam_probability_text(contrlo_array)).to eq 0.5
    end

  end
end
