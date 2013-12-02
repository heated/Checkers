require_relative 'board.rb'
require_relative 'player.rb'
require 'socket'

class Game
  def initialize(players)
    @players = players
    @board = Board.new
    setup_pieces

    pawn = @board[[0, 5]]
    enemy = @board[[1, 2]]

    pawn.perform_moves([[1, 4]])
    pawn.perform_moves([[2, 3]])

    enemy.perform_moves([[3, 4]])
  end

  def play
    current_player = :b
    until @board.over?
      puts "\n#{print_current_player(current_player)} to play."
      begin
        @players[current_player].play_turn(@board, current_player)
      rescue => e
        puts e.message
        retry
      end

      current_player = (current_player == :b ? :r : :b)
    end

    end_game
  end

  private
  def setup_pieces
    [true, false].each do |first_player|
      3.times do |row|
        8.times do |col|
          color = first_player ? :b : :r
          mod_row = first_player ? row + 5 : row
          Piece.new(color, [col, mod_row], @board) if (col + mod_row).odd?
        end
      end
    end
  end

  def print_current_player(color)
    color == :b ? "Black" : "Red"
  end

  def end_game
    if @board.draw?
      puts "game is a draw!"
    else
      puts "Congratulations, #{@players[@board.winner].name} wins!"
    end
  end
end

John = HumanPlayer.new("John")
Fred = HumanPlayer.new("Fred")

funtimes = Game.new( {:b => John, :r => Fred} )
funtimes.play