require_relative 'piece.rb'
require 'colorize'

class Board
	def initialize(empty = false)
    init_board
		init_pieces unless empty
	end

  def init_board
    @grid = Array.new(8) { Array.new(8) }
  end

	def init_pieces
		[true, false].each do |first_player|
			3.times do |row|
				8.times do |col|
					color = first_player ? :b : :r
					mod_row = first_player ? row + 5 : row
					Piece.new(color, [col, mod_row], self) if (col + mod_row).odd?
				end
			end
		end
	end

	def [](pos)
		i, j = pos
		@grid[i][j]
	end

	def []=(pos, piece)
		i, j = pos
		@grid[i][j] = piece
	end

	def move(pos1, pos2)
		unless self.empty?(pos1)
			piece = self[pos1]
			# TODO
		end
	end

  def dup
    new_board = Board.new(true)
    pieces.each do |piece|
      piece.dup(new_board)
    end
    new_board
  end

  def pieces
    @grid.flatten.reject { |piece| piece.nil? }
  end

	def empty?(pos)
		on_board?(pos) && self[pos].nil?
	end

	def on_board?(pos)
		pos.all? { |coord| (0...8).include?(coord) }
	end

	def enemy?(pos, color)
		on_board?(pos) && !empty?(pos) && self[pos].color != color
	end

	def to_s
		str = ""
		@grid.size.times do |x|
			@grid.size.times do |y|
				# account for terminal output
				piece = @grid[y][x] 

				new_str = (piece.nil? ? " " : piece.to_s)
				new_str += " "

        str << ((x + y).even? ? new_str.black.on_white :
                                new_str.black.on_green)
			end
			str << "\n"
		end

		str
	end
end

board = Board.new

pawn = board[[0, 5]]
enemy = board[[1, 2]]

pawn.perform_moves([[1, 4]])
pawn.perform_moves([[2, 3]])

enemy.perform_moves([[3, 4]])

# board.move([5, 1], [4, 2])

puts board