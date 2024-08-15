require_relative "lib/hangman"
require "colorize"

def intro
  puts "Hangman".center(62, "*").colorize(color: :blue, mode: :bold)
end

def menu
  puts "1 - Play game\n2 - How to play\n3 - Load Game\n4 - Exit"
  opcao = gets.to_i
  unless [1, 2, 3, 4].include?(opcao)
    puts "Wrong Option. Try again".colorize(color: :red, mode: :bold)
    puts "1 - Play the game\n2 - How to play\n 3 - Load Game\n4 - Exit"
    opcao = gets.to_i
  end
  opcao
end

def how_to_play
  puts "You must guess the word before you lives #{'run out'.colorize(:red)}\n\n"
  puts "Press enter to continue".colorize(color: :red)
  gets
end

def start_game(game, player)
  while game.check_winner && game.lifes.positive?
    system "clear"
    intro
    game.print_word
    game.check_player_word(player.choose_letter(game))
  end
end

def load_game(game)
  begin # rubocop:disable Style/RedundantBegin
    file = CSV.open("data.csv")
    file.each do |row|
      if row[0] == "word"
        game.word = row[1].to_s
      elsif row[0] == "player_word"
        game.player_word = row[1].to_s
      else
        game.lifes = row[1].to_i
      end
    end
  rescue StandardError
    puts "There is no data to load, press enter to start a new game".colorize(:red)
    gets
  end
end

include Hangman

in_game = true

while in_game == true
  system "clear"
  intro
  opcao = menu
  case opcao
  when 1
    game = Game.new
    player = Player.new
    start_game(game, player)
  when 2
    how_to_play
  when 3
    game = Game.new
    player = Player.new
    load_game(game)
    start_game(game, player)
    gets
  else
    exit
  end
end
