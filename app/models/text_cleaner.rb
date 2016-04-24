class TextCleaner < ActiveRecord::Base

  FFI::Hunspell.directories.unshift(File.join(File.dirname(__FILE__), 'include/dict/'))


  def self.delete_punctuation(text_with_punctuation)
    text_without_punctuation = text_with_punctuation.gsub(/[\-\!\.\,\;\…\«\»\:\–\—\(\)\?\\\"1234567890]/, "")
  end

  def self.split(text)
    words =  text.split(' ')
  end

  def self.uk_hunspel_word(array_of_any_words)
    array_of_uk_dictionary_words = Array.new
    dict_uk = FFI::Hunspell.dict('uk_UA')

    array_of_any_words.each do |word|
      array_of_uk_dictionary_words.push(dict_uk.stem(word)).flatten!
    end

    array_of_uk_dictionary_words
  end

  def self.ru_hunspel_word(array_of_any_words)
    array_of_ru_dictionary_words = Array.new
    dict_ru = FFI::Hunspell.dict('ru_RU')

    array_of_any_words.each do |word|
      array_of_ru_dictionary_words.push(dict_ru.stem(word)).flatten!
    end

    array_of_ru_dictionary_words
  end

  def self.check_lenguage(text)
    language = :ukrainian
    text_without_punctuation = delete_punctuation(text)
    array_of_any_words = split(text_without_punctuation)

    number_of_ukrainian_words = uk_hunspel_word(array_of_any_words).length
    number_of_russian_words = ru_hunspel_word(array_of_any_words).length

    if number_of_russian_words >= number_of_ukrainian_words
      language = :russian
    elsif number_of_russian_words < number_of_ukrainian_words
      language = :ukrainian
    end

  end

  def self.clean_text(text)
    language = check_lenguage(text)

    text_without_punctuation = delete_punctuation(text)
    array_of_any_words = split(text_without_punctuation)

    if language == :russian
      dictionary_words_with_duplication = ru_hunspel_word(array_of_any_words)
    elsif language == :ukrainian
      dictionary_words_with_duplication = uk_hunspel_word(array_of_any_words)
    end

    dictionary_words = dictionary_words_with_duplication.uniq

  end
end
