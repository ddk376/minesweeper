require_relative 'tile'

class Board
  attr_reader :size, :bombs, :grid

  def intialize(size = 9, bombs = 10)
    @grid = Array.new(size) { Array.new(size) }
    @bombs = bombs
  end

  def populate
    bomb_pos = bomb_positions
    (0..grid.size - 1) do |y|
      (0..grid[0].size - 1) do |x|
        if bomb_pos.include?([x,y])
          self[[x,y]] = Tile.new([x,y], true, self)
        else
          self[[x,y]] = Tile.new([x,y], false, self)
        end
      end
    end
  end

  def bomb_positions
    bomb_positions = []
    bombs.times do
      rand_pos = [rand(grid.size), rand(grid.size)]
      bomb_positions << rand_pos if !bomb_positions.include?(rand_pos)
    end
    bomb_positions
  end
end
