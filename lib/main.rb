module Dictionary
  File.open('dictionary.txt', 'r')
  dictionary_content = File.read('dictionary.txt')
  WORDS = dictionary_content.split(' ').select { |word| word.length >= 5 && word.length <= 12}
end

class Board
  include Dictionary
  attr_accessor :secret_word

  def initialize
    @secret_word = WORDS.sample
  end
end
