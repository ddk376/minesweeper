require 'colorize'

class Tile
  DIRECTIONS = [[-1,-1],
                [-1,0],
                [-1,1],
                [0,-1],
                [0,1],
                [1,-1],
                [1,0],
                [1,1]]

  attr_accessor :flagged, :revealed
  attr_reader :bomb, :board, :pos

  def initialize(pos, bomb, board)
    @pos = pos
    @bomb = bomb
    @board = board
    @flagged = false
    @revealed = false
  end

  def reveal
    self.revealed = true if !flagged

    nil
  end

  def flag
    self.flagged = true if !revealed

    nil
  end

  def neighbors
    neighbors = DIRECTIONS.map do |neighbor|
      new_pos = [pos[0] + neighbor[0], pos[1] + neighbor[1]]
      board.on_board?(new_pos) ? new_pos : nil
    end
    neighbors.compact
  end

  def neighbor_bomb_count
    counter = 0
    neighbors.each do |pos|
      counter += 1 if board[pos].bomb
    end
    counter
  end

  def to_s
    return "F ".red.on_white if flagged
    return "  ".white.on_white if !revealed
    neighbor_bombs = neighbor_bomb_count
    if bomb
      "* ".black.on_red
    elsif neighbor_bombs > 0
      "#{neighbor_bombs} ".white.on_black
    else
      "  ".white.on_black
    end
  end

  def switch_flag
    self.flagged = (flagged ? false : true)
  end

  def flagged?
    @flagged
  end

end
