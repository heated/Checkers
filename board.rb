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
    str = "\e[H\e[2Jx  a b c d e f g h \n"

    @grid.size.times do |y|
      str << "\n" + (8 - y).to_s + " "
			@grid.size.times do |x|
        str << render(x, y)
			end
		end

		str
	end

  def render(x, y)
    # account for terminal output
    piece = @grid[x][y]

    unless piece.nil?
      new_str = piece.to_s
      new_str = (piece.color == :r ? new_str.red.on_green :
                                     new_str.black.on_green)
    else
      new_str = "  "
      new_str = ((x + y).even? ? new_str.on_white :
                                 new_str.on_green)
    end
  end
end