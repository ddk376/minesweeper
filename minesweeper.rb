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
    if valid?(action, pos)
      if action == "F"
        board[pos].switch_flag
      else
        reveal_space(pos)
      end
    end
  end

  def reveal_pos(pos)
    if board[pos].bomb
      game_over
    else
      reveal_neighbors(pos)
    end
  end

  def reveal_neighbors(pos)
    neighbor_bomb_count = board[pos].neighbor_bomb_count
    return neighbor_bomb_count if neighbor_bomb_count > 0

    board[pos].neighbors.each do |neighbor| 
      reveal_neighbors(neighbor) if !board[neighbor].bomb
    end
  end

  def valid?(action, pos)
    return false if !on_board?(pos) &&
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
    pos.all? { |coord| coord.between?(0, board.length - 1) }
  end
end
