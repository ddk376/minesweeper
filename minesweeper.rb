require_relative "board"

class Minesweeper
  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def take_turn
    input = gets.chomp
    action = input[0]
    pos = [input[1], input[2]]
    
  end
end
