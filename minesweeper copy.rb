require 'io/console'
require_relative "board"
require "yaml"

class Minesweeper
  attr_accessor :board

  def initialize(file_name = nil)
    @board = Board.new
    file_name && File.exist?(file_name) ? load(file_name).play : play
  end

  def play
    until won?
      take_turn
    end
    display "You won!"
  end

  def take_turn
    board.render
    input = gets.chomp
    action = input[0].upcase
    pos = [input[1].to_i, input[2].to_i]
    if action == "S"
      save_game
    elsif action == "L"
      load_game
    elsif valid?(action, pos)
      if action == "F"
        board[pos].switch_flag
      else
        reveal_pos(pos)
      end
    end
  end


  def reveal_pos(pos)
    if board[pos].bomb
      loss
    else
      reveal_neighbors(pos)
    end
  end

  def reveal_neighbors(pos)
    neighbor_bomb_count = board[pos].neighbor_bomb_count

    board[pos].reveal
    return if neighbor_bomb_count > 0

    board[pos].neighbors.each do |neighbor|
      if !board[neighbor].bomb && !board[neighbor].revealed
        reveal_neighbors(neighbor)
      end
    end
  end

  def valid?(action, pos)
    return false if !board.on_board?(pos)
    if action == "R"
      !board[pos].revealed && !board[pos].flagged
    elsif action == "F"
      !board[pos].revealed
    else
      false
    end
  end

  def loss
    board.bomb_locations.each do |location|
      board[location].reveal
    end
    board.render
    puts "You lose!"
    abort
  end

  def won?
    board.grid.flatten.all? do |space|
      space.bomb ? space.flagged : space.revealed
    end
  end

  def save_game
    print "Enter file name: "
    file_name = gets.chomp
    game = self.to_yaml
    File.open("saved_games/#{file_name}.txt", "w") { |file| file.write(game) }
    abort
  end

  def load_game
    print "Enter file name: "
    file_name = gets.chomp
    game = load(file_name)
    game.play
  end

  def load(file_name)
    YAML::load(File.read("saved_games/#{file_name}.txt"))
  end
end

if __FILE__ == $PROGRAM_NAME
  game = ARGV.shift
  x = Minesweeper.new(game)
end
