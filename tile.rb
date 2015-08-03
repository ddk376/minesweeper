require 'colorize'
require_relative 'board'

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
    self.revealed = true if flagged == false

    nil
  end

  def flag
    self.flagged = true if revealed == false

    nil
  end

  def neighbors
    neighbors = DIRECTIONS.map do |neighbor|
      new_pos = [pos[0] + neighbor[0], pos[1] + neighbor[1]]
      on_board?(new_pos) ? new_pos : nil
    end
    neighbors.compact
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, board.length - 1) }
  end

  def neighbor_bomb_count
    counter = 0
    neighbors.each do |pos|
      counter += 1 if board[pos].bomb
    end
    counter
  end

  def inspect
    return "F".red.on_white if flagged
    return " ".black.on_white if !revealed
    if bomb
      "*".black.on_red
    elsif neighbor_bomb_count > 0
      "#{neighbor_bomb_count}".white.on_black
    else
      " ".white.on_black
    end
  end
end
