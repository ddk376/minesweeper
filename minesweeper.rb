require_relative "board"

class Minesweeper
  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def take_turn
    input = gets.chomp
    action = input[0].upcase
    pos = [input[1], input[2]]

  end

  def valid?(action, pos)
    return false if !on_board?(pos) &&
    if action == "R"
      @board[pos].revealed == false &&
      @board[pos].flagged == false
    elsif action == "F"
      @board[pos].revealed == false
    else
      false
    end
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, board.length - 1) }
  end
end
