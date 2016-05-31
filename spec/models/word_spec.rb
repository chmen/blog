require 'spec_helper'

=begin
describe Word do
  it "do some shit"
  it "do very big shit"
end
=end

describe Word, "#spam_probability_word" do 
  word1 = Word.new
  word1.name = 'авария'
  word1.spam = 2
  word1.ham = 5

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
