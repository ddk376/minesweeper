require 'colorize'

class Tile
  attr_accessor :flagged, :revealed
  attr_reader :bomb, :board

  def initialize(bomb, board)
    @bomb = bomb
    @board = board
    @flagged = false
    @revealed = false
  end
end
