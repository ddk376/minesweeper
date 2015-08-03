require_relative "board"

class Minesweeper
  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def play
    until won?
      take_turn
    end
    display "You won!"
  end

  def take_turn
    board.render
    input = gets.chomp
    action = input[0].upcase
    pos = [input[1].to_i, input[2].to_i]
    if valid?(action, pos)
      if action == "F"
        board[pos].switch_flag
      else
        reveal_pos(pos)
      end
    end
  end

  def reveal_pos(pos)
    if board[pos].bomb
      loss
    else
      reveal_neighbors(pos)
    end
  end

  def reveal_neighbors(pos)
    neighbor_bomb_count = board[pos].neighbor_bomb_count

    board[pos].reveal
    return if neighbor_bomb_count > 0

    board[pos].neighbors.each do |neighbor|
      if !board[neighbor].bomb && !board[neighbor].revealed
        reveal_neighbors(neighbor)
      end
    end
  end

  def valid?(action, pos)
    return false if !on_board?(pos)
    if action == "R"
      board[pos].revealed == false &&
      board[pos].flagged == false
    elsif action == "F"
      board[pos].revealed == false
    else
      false
    end
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, board.grid.length - 1) }
  end

  def loss
    board.bomb_locations.each do |location|
      board[location].reveal
    end
    board.render
    puts "You lose!"
    abort
  end

  def won?
    (0..(board.grid.size - 1)).each do |y|
      (0..(board.grid[0].size - 1)).each do |x|
        return false if !board[[x,y]].revealed && !board[[x,y]].bomb
        return false if board[[x,y]].bomb && !board[[x,y]].flagged
      end
    end
    true
  end
end


x = Minesweeper.new(Board.new).play
