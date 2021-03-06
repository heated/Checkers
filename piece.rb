# encoding: UTF-8
require 'colorize'
class Piece
	attr_reader :color, :pos
  def dup(board)
    Piece.new(@color, @pos, board)
  end

	def initialize(color, pos, board)
		@color, @pos, @board = color, pos, board
		@king = false
		@direction = (@color == :b ? -1 : 1)
		@board[@pos] = self
	end

  def maybe_promote
    y = @pos[1]
    (@color == :b ? y == 0 : y == 7)
  end

  def valid_moves
    valid_slides + jump_chains
  end

  def move_diffs
    forward = [1, -1].product([@direction])
    all_dirs = [1, -1].product([1, -1])

    dirs = (king? ? all_dirs : forward)

    moves = [[], []]
    x, y = @pos

    dirs.each do |dir|
      dx, dy = dir
      moves[0] << [x + dx, y + dy]
      moves[1] << [x + 2 * dx, y + 2 * dy]
    end

    moves
  end

  def perform_moves(moves)
    if valid_move_seq?(moves)
      perform_moves!(moves)
    else
      raise InvalidMoveError.new
    end
  end

  def perform_moves!(moves)
    if moves.length == 1
      move = moves[0]
      raise InvalidMoveError.new unless perform_slide(move) || 
                                        perform_jump(move)
    else
      raise InvalidMoveError.new unless moves.all? do |move|
        perform_jump(move)
      end
    end
  end

  def perform_jump(new_pos)
    landings = move_diffs[1]
    jumps = move_diffs[0]

    dir = landings.index(new_pos)

    jumpable = !dir.nil? &&
      @board.empty?(new_pos) &&
      @board.enemy?(jumps[dir], @color)

    if jumpable
      self.pos = new_pos
      @board[jumps[dir]] = nil
      maybe_promote
    end

    jumpable
  end

  def perform_slide(new_pos)
    slideable = move_diffs[0].include?(new_pos) && @board.empty?(new_pos)

    if slideable
      self.pos = new_pos
      maybe_promote
    end

    slideable
  end

	def pos=(new_pos)
		@board[@pos] = nil
		@board[new_pos] = self
		@pos = new_pos
	end

	def promote
		@king = true
	end

	def king?
		@king
	end

	def to_s
    if king?
      "◉ "
    else
      "● "
    end
	end

  def jump_chains
    rec_possible_jumps
      .map { |jumps| jumps.drop(1) }
      .reject { |jumps| jumps.empty? }
  end

  def rec_possible_jumps
    return [[@pos]] if valid_jumps.empty?

    jump_list = []
    valid_jumps.each do |jump|
      test_board = @board.dup
      test_piece = test_board[@pos]
      test_piece.perform_jump(jump)
      jump_list += test_piece.rec_possible_jumps
    end

    jump_list.map { |jumps| [@pos] + jumps }
  end

  def valid_jumps
    move_diffs[1].select { |jump| valid_move_seq?([jump]) }
  end

  def valid_move_seq?(moves)
    test_board = @board.dup
    test_piece = test_board[@pos]
    begin
      test_piece.perform_moves!(moves)
    rescue
      false
    else
      true
    end
  end

  def valid_slides
    move_diffs[0]
      .select { |slide| valid_move_seq?([slide]) }
      .map { |slide| [slide] }
  end
end

class InvalidMoveError < StandardError 
end