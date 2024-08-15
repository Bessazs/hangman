require "csv"

module Hangman
  class Game
    def pick_words
      words = File.read("words.txt")
      words = words.split
      array_word = []
      words.each do |word|
        array_word.push(word) if word.size.between?(5, 12)
      end

      array_word.sample(1).join.upcase
    end

    attr_accessor :lifes, :player_word, :word

    def initialize
      @word = pick_words
      @player_word = "_" * @word.size
      @lifes = 6
    end

    def check_player_word(character)
      count = 0
      indexs = []
      @word.each_char.with_index do |char, index|
        if character == char
          count += 1
          indexs.push(index)
        end
      end
      @lifes -= 1 if count.zero?
      puts
      indexs.each do |idx|
        @player_word[idx] = character
      end
      print_word
    end

    def print_word
      puts "#{@player_word.colorize(:green)},  #{@lifes} lifes Reamining"
    end

    def check_winner
      if @lifes.zero?
        puts "#{'You loose'.colorize(:red)}. press Enter to back to menu"
        gets
      end
      unless @player_word.include?("_")
        puts "Congratulations, you win the game\n\n".colorize(color: :yellow, mode: :bold)
        puts "Press enter to continue".colorize(color: :red)
        gets
        return false
      end
      true
    end

    def save_game
      data = "word,#{@word}\nplayer_word,#{player_word}\nlifes,#{@lifes}"
      path = "data.csv"
      File.write(path, data)
      exit
    end
  end

  class Player
    def choose_letter(game)
      puts "Enter a character or digit 'SAVE' to save the game and exit:"
      chara = gets.chomp.upcase
      game.save_game if chara == "SAVE"
      while chara.size != 1
        puts "Enter with #{'ONE'.colorize(:red)} character or digit 'SAVE' to save the game and exit:"
        chara = gets.chomp.upcase
        game.save_game if chara == "SAVE"
      end
      chara
    end
  end
end
