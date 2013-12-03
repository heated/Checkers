require_relative 'piece.rb'
require 'colorize'

class Board
	def initialize
    init_board
	end

  def init_board
    @grid = Array.new(8) { Array.new(8) }
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
    new_board = Board.new
    all_pieces.each do |piece|
      piece.dup(new_board)
    end
    new_board
  end

  def pieces(color)
    all_pieces.reject { |piece| piece.color != color }
  end

  def all_pieces
    @grid.flatten.reject { |piece| piece.nil? }
  end

	def empty?(pos)
		on_board?(pos) && self[pos].nil?
	end

	def on_board?(pos)
		pos.all? { |coord| (0...8).include?(coord) }
	end

  def winner
    pieces(:b).empty? ? :r : :b
  end

  def over?
    pieces(:b).empty? || pieces(:r).empty?
  end

	def enemy?(pos, color)
		on_board?(pos) && !empty?(pos) && self[pos].color != color
	end

	def to_s
    # \e[H\e[2J
    str = "x  a b c d e f g h \n"

    @grid.size.times do |y|
      str << "\n" + (8 - y).to_s + " "
			@grid.size.times do |x|
				# account for terminal output
				piece = @grid[x][y] 

				new_str = (piece.nil? ? " " : piece.to_s)
				new_str += " "

        str << ((x + y).even? ? new_str.black.on_white :
                                new_str.black.on_green)
			end
		end

		str
	end
end