class HumanPlayer
  attr_reader :name
  def initialize(name = "John")
    @name = name
  end

  def play_turn(board, color)
    puts "\nPick a piece to move."
    piece_pos = parse_input(board)

    raise "That isn't your piece!" if board.enemy?(piece_pos, color)
    raise "There's no piece there!" if board.empty?(piece_pos)
    raise "That's not even a coordinate" unless board.on_board?(piece_pos)

    board.show_moves(piece_pos)
    p board

    puts "\nWhere do you want to move to?"
    move_to_pos = parse_input(board)

    board.hide_moves

    board.move(piece_pos, move_to_pos)
  end

  # a - h, 1 - 8
  private
  def parse_input(input)
    letters = ("a".."h").to_a

    coords = input.split("").map(&:strip)
    coords[0] = letters.index(coords.first)
    coords[1] = 8 - Integer(coords.last)
    coords
  end
end