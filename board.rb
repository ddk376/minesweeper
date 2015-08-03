require_relative 'tile'

class Board
  attr_accessor :cursor
  attr_reader :bombs, :grid, :bomb_locations

  def initialize(size = 9, bombs = 10)
    @grid = Array.new(size) { Array.new(size) }
    @cursor = [0,0]
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
    puts " 0 1 2 3 4 5 6 7 8"
    (0..(grid.size - 1)).each do |y|
      print "#{y}"
      (0..(grid[0].size - 1)).each do |x|
        print ( cursor == [x,y] ? "  ".blue.on_blue : self[[x,y]].to_s )
      end
      puts
    end
  end

  def cursor_up
    cusor[1] -= 1
  end

  def cursor_down
    cursor[1] += 1
  end

  def cursor_left
    cursor[0] -= 1
  end

  def cursor_right
    cursor[0] += 1
  end

  def check_cursor
    self.cusor.map! do |coord|
      coord = board.size if coord > board.size
      coord = 0 if coord < 0
    end
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, grid.length - 1) }
  end
end
