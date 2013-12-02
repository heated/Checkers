class HumanPlayer
  attr_reader :name
  def initialize(name = "John")
    @name = name
  end

  def play_turn(board, color)
    puts board
    puts "\nPick a piece to move."
    piece_pos = parse_loc(gets.chomp)

    raise "That isn't your piece!" if board.enemy?(piece_pos, color)
    raise "There's no piece there!" if board.empty?(piece_pos)
    raise "That's not even a coordinate" unless board.on_board?(piece_pos)

    piece = board[piece_pos]

    puts "\nWhere do you want to move to?"
    move_list = parse_input(gets.chomp)

    piece.perform_moves(move_list)
  end

  # a - h, 1 - 8
  private
  def parse_input(input)
    input_list = input.split(",").map(&:strip)
    input_list.map { |move| parse_loc(move) }
  end

  def parse_loc(input)
    letters = ("a".."h").to_a

    coords = input.split("").map(&:strip)
    coords[0] = letters.index(coords.first)
    coords[1] = 8 - Integer(coords.last)
    coords
  end
end