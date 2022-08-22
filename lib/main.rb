module Dictionary
  File.open('dictionary.txt', 'r')
  dictionary_content = File.read('dictionary.txt')
  WORDS = dictionary_content.split(' ').select { |word| word.length >= 5 && word.length <= 12}
end

class Board
  include Dictionary
  attr_accessor :secret_word, :hint, :incorrect_guesses, :print

  def initialize
    @secret_word = WORDS.sample
    @hint = []
    @incorrect_guesses = 0
  end

  def initial_hint
    secret_word.split('').each { |letter| hint.push('_') }
  end

  def print
    puts "#{hint.join(' ')}\n\n"
  end

  def guess_check(guess)
    if secret_word.include?(guess)
      puts 'Correct'
      secret_word.split('').each_with_index do |letter, index|
        if letter == guess
          self.hint[index] = guess
        end
      end
    elsif !secret_word.include?(guess)
      puts "Incorrect"
      self.incorrect_guesses += 1
    end
  end
end

class Player
  attr_accessor :guessed_letters, :guess

  def initialize
    @guess = ''
    @guessed_letters = []
  end

  def make_guess
    puts 'Guess a letter:'
    current_guess = ''

    until current_guess.match /\A[a-zA-Z'-]{1}\z/
      current_guess = gets.chomp.downcase
    end

    current_guess
  end

  def duplicate_check(current_guess)
    duplicate = false
    if !self.guessed_letters.include?(current_guess)
      guessed_letters.push(current_guess)
      self.guess = current_guess
    else
      duplicate = true
    end
    duplicate
  end
end

class Game
  attr_accessor :player, :board
  def initialize
    @player = Player.new
    @board = Board.new
  end

  def game_over_check
    game_over = false
    if board.incorrect_guesses == 6
      puts "You ran out of guesses. The word was #{board.secret_word}"
      game_over = true
    elsif board.hint.join('') == board.secret_word
      puts "You win lol"
      game_over = true
    end
    game_over
  end

  def instructions
    puts "Welcome to hangman! Guess the letters, it's game over if you get 6 wrong letters."
    board.initial_hint
    board.print
  end

  def play
    instructions
    
    until game_over_check == true
      puts "Letters guessed so far: #{player.guessed_letters}\n\n"
      if player.duplicate_check(player.make_guess)
        puts "Letter already guessed.\n\n"
        board.print
        next
      end
      board.guess_check(player.guess)
      board.print
    end
  end
end

game = Game.new
game.play
