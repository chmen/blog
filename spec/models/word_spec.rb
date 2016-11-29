require 'spec_helper'

describe Word do

  # TO DO: after refactor it should contein no russian words

  describe ".mass_train" do
    context "with spam text(status 2)" do

      it " increase spam value of existatnt word by 1" do
        word = FactoryGirl.create(:word)
        spam_text = " #{word.name} - хорошее русское слово"
        start_spam = word.spam
        
        #problem is here
        Word.mass_train(spam_text, 2)
        
        updated_word = Word.where(name: word.name).take
        expect(updated_word.spam). to eq (start_spam + 1)
      end

      it "leaves ham value without changes" do
        word = FactoryGirl.create(:word)
        spam_text = " #{word.name} - хорошее русское слово"
        start_ham = word.ham
        Word.mass_train(spam_text, 2)
        
        updated_word = Word.where(name: word.name).take
        expect(updated_word.ham). to eq start_ham
      end
    end

    context "with ham text(status 1)" do

      it " increase ham value of existatnt word by 1" do
        word = FactoryGirl.create(:word)
        ham_text = " #{word.name} - хорошее русское слово"
        start_ham = word.ham
        Word.mass_train(ham_text, 1)
        
        updated_word = Word.where(name: word.name).take
        expect(updated_word.ham). to eq (start_ham + 1)
      end
    end

  end

  describe ".train" do
    context "with existent word" do
      context " if status 2(spam)" do
        
        it "increases spam value by 1 " do
          word = FactoryGirl.create(:word)
          start_spam = word.spam
          expect(Word.train(word.name, word.language, 2).spam).to eq (start_spam + 1)
        end

        it "leaves ham value without changes" do
          word = FactoryGirl.create(:word)
          start_ham = word.ham
          expect(Word.train(word.name, word.language, 2).ham).to eq (start_ham)
        end
      end
    end

    context "with nonexistent word" do
      context " if status 1(ham)" do
        it "increase ham value to 1" do
          expect(Word.train("атом", "rus", 1).ham).to eq 1
        end
        it "leaves spam value 0" do
          expect(Word.train("атом", "rus", 1).spam).to eq 0
        end
      end
    end

  end

  describe ".get_or_new" do
    context "with exist word" do
      word = FactoryGirl.build(:word)
      language = "rus"

      it "return word with same name" do
        expect(Word.get_or_new(word.name, language).name).to eq word.name
      end
      it "return object of class Word" do
        expect(Word.get_or_new(word.name, language).class).to eq Word
      end
      it "return word with proper language" do
        expect(Word.get_or_new(word.name, language).language).to eq word.language
      end
    end

    context "with nonexistent word" do

      name = "яблоко"
      language = "rus"

      it "create new word" do
        expect(Word.get_or_new(name, language).class).to eq Word
      end
      it "create word with proper name " do
        expect(Word.get_or_new(name, language).name).to eq name
      end
      it "return word with proper language" do
        expect(Word.get_or_new(name, language).language).to eq language
      end
      it "return spam value 0" do
        expect(Word.get_or_new(name, language).spam).to eq 0
      end
      it "return ham value 0" do
        expect(Word.get_or_new(name, language).ham).to eq 0
      end
    end

  end

  describe  ".spam_probability_word" do
    context "with spam word" do
      word = FactoryGirl.build(:word, spam: 20, ham: 2)
      train_session = FactoryGirl.build(:text_count)

      it "returns probability more then 0.5" do
        expect(Word.spam_probability_word(word, train_session)).to be > 0.5
      end
    end

    context "with ham word" do
      word = FactoryGirl.build(:word)
      train_session = FactoryGirl.build(:text_count)

      it "returns probability less then 0.5" do
        expect(Word.spam_probability_word(word, train_session)).to be < 0.5
      end
    end

  end

  describe ".remove_100_percent_probabilitys" do 
    words_probabilities_one = [0.67, 0.9, 0.85, 0.1, 0.7, 1.0]
    words_probabilities_several = [0.67, 1.0, 1.0, 0.9, 0.85, 0.1, 0.7, 1.0]
    words_probabilities = [0.67, 0.9, 0.85, 0.1, 0.7]
    control_words_probabilities = [0.2, 0.8, 0.5]

    context "with arrray that contain one word with 100 percent probability" do
      it "remove one 100 percent probability" do
        expect(Word.remove_100_percent_probabilitys(words_probabilities_one)).to eq words_probabilities
      end
    end

    context "with arrray that contain several words with 100 percent probability" do
      it "remove all 100 percent probabilitys" do
        expect(Word.remove_100_percent_probabilitys(words_probabilities_several)).to eq words_probabilities
      end
    end

    context "wothout any words with 100 percent probability" do
      it "leaves without changes" do
        expect(Word.remove_100_percent_probabilitys(control_words_probabilities)).to eq control_words_probabilities
      end
    end

  end


  describe ".spam_probability_text" do
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

  describe ".generate_list_of_exist_words" do

    context "with array of both exista and non exist words" do

        clean_words = ["атом", "реактор", "кот", "собака", "Валентин"]
        
        language = "rus"
        it "return array of word, that exist in Word class" do
          word = FactoryGirl.create(:word)
          word2 = FactoryGirl.create(:word, name: "атом")
          exist_words = [word, word2]
          expect(Word.generate_list_of_exist_words(clean_words, language).sort).to eq exist_words.sort

      end
    end

    context "with array of non exist words" do
      clean_words = ["улица", "пылать", "барикада"]
      exist_words = []
      language = "rus"

      it "return empty array" do
        expect(Word.generate_list_of_exist_words(clean_words, language)).to eq exist_words
      end
    end

    context "with array of existent word, but with wrong language" do
      clean_words = ["ДТП", "каштан"]
      exist_words = []
      language = "ukr"

      it "return empty array" do
        expect(Word.generate_list_of_exist_words(clean_words, language)).to eq exist_words
      end

    end
  end
=begin
  describe ".analyze" do

    context "with spam text" do
      it "returns status 2" do
#        word1 = FactoryGirl.create(:word, name: "каштан", ham: 1)
#        train_session = FactoryGirl.create(:text_count)
        feed = FactoryGirl.create(:feed)

        #expect(Word.analyze(feed, train_session)).to be 2
      end
    end

    context "with ham text" do
      it "returns status 1" do
        word1 = FactoryGirl.create(:word)
        train_session = FactoryGirl.create(:text_count)
        feed = FactoryGirl.create(:feed, summary: "чернобыльская катастрофа — разрушение 26 апреля 1986 года четвёртого энергоблока Чернобыльской атомной электростанции, расположенной на территории Украинской ССР (ныне — Украина). Разрушение носило взрывной характер, реактор был полностью разрушен, и в окружающую среду было выброшено большое количество радиоактивных веществ.")
 
        expect(Word.analyze(feed, train_session)).to be 1
      end
    end
=end
=begin
    context "with empty summery"
    feed = FactoryGirl.build(:feed, summery: "")
    it "return status 0" do
      expect(Word.analyze(feed, train_session)).to be 0
    end

  end
=end
end
