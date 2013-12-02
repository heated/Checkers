require_relative 'piece.rb'
require 'colorize'

class Board
	def initialize
		@grid = Array.new(8) { Array.new(8) }
		init_pieces
	end

	def init_pieces
		[true, false].each do |first_player|
			3.times do |row|
				8.times do |col|
					color = first_player ? :b : :r
					mod_row = first_player ? row + 5 : row
					Piece.new(color, [mod_row, col], self) if (row + col).even?
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
		
	end

	def empty?(pos)
		self[pos].nil?
	end

	def to_s
		str = ""
		@grid.each do |row|
			row.each do |piece|
				unless piece.nil?
					if piece.color == :b
						str << piece.to_s.black
					else
						str << piece.to_s.red
					end
				else
					str << " "
				end
				str << "|"
			end
			str << "\n"
		end

		str
	end
end

board = Board.new

puts board