require_relative 'tile'

class Board
  attr_reader :size, :bombs

  def intialize(size = 9, bombs = 10)
    @grid = Array.new(size) { Array.new(size) }
    @bombs = bombs
  end
end
