require_relative "board"
require "yaml"

class Minesweeper
  attr_accessor :board

  def initialize(board)
    @board = board
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
    game = self.to_yaml
    File.open("saved_games.txt", "w") { |file| file.write(game) }
    abort
  end

  def load_game
    game = YAML::load(File.read("saved_games.txt"))
    game.play
  end
end


x = Minesweeper.new(Board.new).play
