require 'spec_helper'

describe Word do

  # TO DO: remove this section after integretion of Factory
  # TO DO: after refactor it should contein no russian words
  #
  word2 = Word.new
  word2.name = 'чернобыльский'
  word2.language = 'rus'
  word2.spam = 2
  word2.ham = 9

  word3 = Word.new
  word3.name = 'ДТП'
  word3.language = 'rus'
  word3.spam = 9
  word3.ham = 1

  word8 = Word.new
  word8.name = 'реактор'
  word8.language = 'rus'
  word8.spam = 2
  word8.ham = 9

  word9 = Word.new
  word9.name = 'атомный'
  word9.language = 'rus'
  word9.spam = 2
  word9.ham = 9

  word10 = Word.new
  word10.name = 'авария'
  word10.language = 'rus'
  word10.spam = 9
  word10.ham = 1

  word4 = Word.new
  word4.name = 'радиоактивный'
  word4.language = 'rus'
  word4.spam = 1
  word4.ham = 7

  word5 = Word.new
  word5.name = 'каштан'
  word5.language = 'rus'
  word5.spam = 12
  word5.ham = 1

  word6 = Word.new
  word6.name = 'красный'
  word6.language = 'rus'
  word6.spam = 5
  word6.ham = 5

  word7 = Word.new
  word7.name = 'гибрид'
  word7.language = 'rus'
  word7.spam = 8
  word7.ham = 3

  words = [word2, word3, word4, word5, word6, word7, word8, word9, word10]

  describe ".get_or_new" do
    context "with exist word" do
      it "return word with same name" do 
        #by some reason it work only if compare names, but not words itself
        expect(Word.get_or_new("реактор", "rus", words).name).to eq word8.name
      end
      it "return object of class Word" do
        expect(Word.get_or_new("реактор", "rus", words).class).to eq Word
      end
      it "return word with proper language" do
        expect(Word.get_or_new("реактор", "rus", words).language).to eq word8.language
      end
    end
  end

  describe  ".spam_probability_word" do

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
    context "with array of both exist and non exist words" do
      clean_words = ["ДТП", "реактор", "кот", "собака", "Валентин"]
      exist_words = [word3, word8]

      it "return array of word, that exist in Word class" do
        expect(Word.generate_list_of_exist_words(clean_words, words)).to eq exist_words
      end
    end

    context "with array of non exist words" do
      clean_words = ["улица", "пылать", "барикада"]
      exist_words = []

      it "return empty array" do
        expect(Word.generate_list_of_exist_words(clean_words, words)).to eq exist_words
      end
    end

  end



  describe ".analyze" do

    spam_text = "Конский каштан мясо-красный (лат. Aesculus ×carnea) — гибрид конского каштана обыкновенного (Aesculus hippocastanum) и конского каштана красного"
    ham_text = "чернобыльская катастрофа — разрушение 26 апреля 1986 года четвёртого энергоблока Чернобыльской атомной электростанции, расположенной на территории Украинской ССР (ныне — Украина). Разрушение носило взрывной характер, реактор был полностью разрушен, и в окружающую среду было выброшено большое количество радиоактивных веществ."

    context "with spam text" do
      it "returns status 2" do
        expect(Word.analyze(spam_text, words)).to be 2
      end
    end

    context "with ham text" do
      it "returns status 1" do
        expect(Word.analyze(ham_text, words)).to be 1
      end
    end


  end
end
