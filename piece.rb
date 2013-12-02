class Piece
	attr_reader :color

	def initialize(color, pos, board)
		@color, @pos, @board = color, pos, board
		@king = false
		board[pos] = self
	end

	def promote

	end

	def move_diffs
		
	end

	def perform_jump
		
	end

	def perform_slide
		
	end

	def maybe_promote

	end

	def king?
		king
	end

	def to_s
		"o"
	end
end