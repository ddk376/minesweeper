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

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, board.length - 1) }
  end
end
