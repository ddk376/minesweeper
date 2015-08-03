require_relative 'tile'

class Board
  attr_reader :bombs, :grid, :bomb_locations

  def initialize(size = 9, bombs = 10)
    @grid = Array.new(size) { Array.new(size) }
    @bombs = bombs
    populate
  end

  def populate
    @bomb_locations = bomb_positions
    (0..(grid.size - 1)).each do |y|
      (0..(grid[0].size - 1)).each do |x|
        if bomb_locations.include?([x,y])
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

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos,value)
    @grid[pos[0]][pos[1]] = value
  end

  def render
    (0..(grid.size - 1)).each do |y|
      (0..(grid[0].size - 1)).each do |x|
      print self[[x,y]].to_s
      end
      puts
    end
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, grid.length - 1) }
  end
end
