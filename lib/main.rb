require 'yaml'

module Dictionary
  File.open('dictionary.txt', 'r')
  dictionary_content = File.read('dictionary.txt')
  WORDS = dictionary_content.split(' ').select { |word| word.length >= 5 && word.length <= 12}
end

class Game
  include Dictionary
  attr_reader :secret_word, :player, :board, :guessed_letters, :hint, :print
  attr_accessor :guess, :incorrect_guesses
  
  def initialize
    @guess = ''
    @guessed_letters = []
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

  def make_guess
    puts 'Guess a letter:'
    current_guess = ''
    
    until current_guess.match /\A[a-zA-Z'-]{1}\z/ || current_guess.downcase == 'save'
      current_guess = gets.chomp.downcase
      if current_guess.downcase == 'save'
        puts "Game saved!"
        save_game
        next
      elsif current_guess.downcase == 'exit'
        puts "Thanks for playing!"
        exit
      end
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

  def game_over_check
    game_over = false
    if incorrect_guesses == 6
      puts "You ran out of guesses. The word was #{secret_word}"
      puts "Thanks for playing!"
      game_over = true
    elsif hint.join('') == secret_word
      puts "You win! Thanks for playing!"
      game_over = true
    end
    game_over
  end

  def instructions
    puts "Welcome to hangman! Guess the letters, it's game over if you get 6 wrong letters."
    puts "Type save to save your game, or exit to quit."
    initial_hint
    print
  end

  def save_game
    File.open("saved_game.yml", 'w') { |f| f.write(YAML.dump(self))}
  end

  def load_game
    yaml = YAML.safe_load_file('./saved_game.yml', permitted_classes: [Game])
    @guess = yaml.guess
    @guessed_letters = yaml.guessed_letters
    @secret_word = yaml.secret_word
    @hint = yaml.hint
    @incorrect_guesses = yaml.incorrect_guesses
    puts "Game loaded!"
    print
  end

  def play
    instructions
    puts "Load a saved game? (y/n)"
    load = gets.chomp
    load_game if load == 'y'
    until game_over_check == true
      puts "Letters guessed so far: #{guessed_letters}\n\n"
      if duplicate_check(make_guess)
        puts "Letter already guessed.\n\n"
        print
        next
      end
      guess_check(guess)
      print
    end
  end
end

game = Game.new
game.play
