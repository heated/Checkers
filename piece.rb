class Piece
	attr_reader :color

	def initialize(color)
		@color = color
		@king = false
	end

	def promote

	end

	def move_diffs
		
	end

	def perform_jump
		
	end

	def maybe_promote

	end

	def king?
		king
	end
end