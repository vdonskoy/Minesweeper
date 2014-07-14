class Tile
  attr_accessor :board, :coords, :bombed, :revealed, :flagged, :mark

  def initialize(board)
    @bombed = rand(10) < 1 ? true : false
    @revealed = false
    @flagged = false
    @coords = [0,0]
    @board = board
    @mark = "O"
  end

  def reveal
    @revealed = true

    bombs_nearby = self.neighbor_bomb_count

    return @mark = "*" if self.bombed

    if bombs_nearby == 0
      @mark = "_"
      neighbors.each do |neighbor|
        @board.board[neighbor[0]][neighbor[1]].reveal if @board.board[neighbor[0]][neighbor[1]].revealed == false
      end
    else
      @mark = bombs_nearby.to_s
    end
  end

  def flag
    @flagged = true
  end

  ADJS = [
    [-1,-1],
    [-1,0],
    [-1,1],
    [0,-1],
    [0,1],
    [1,-1],
    [1,0],
    [1,1]
  ]

  def neighbors
    neighbors = []
    ADJS.each do |adj|
      x = @coords[0] + adj[0]
      y = @coords[1] + adj[1]
      neighbors << [x,y] unless (x > 8 || y > 8 || x < 0 || y < 0)
    end

    neighbors
  end

  def neighbor_bomb_count
    bombs_nearby = 0

    neighbors.each do |neighbor|
      if @board.board[neighbor[0]][neighbor[1]].bombed
        bombs_nearby += 1
      end
    end

    bombs_nearby
  end
end

class Board
  attr_accessor :board

  def initialize
    @board = []
    i = 0
    while i < 9
      j = 0
      @board << []
      while j < 9
        @board[i][j] = Tile.new(self)
        @board[i][j].coords = [i,j]
        j += 1
      end
      i += 1
    end

    print_board
  end

  def print_board

    @board.each do |row|
      print_row = ""

      row.each do |tile|
        if tile.flagged
          space = "F"
        elsif tile.revealed
          space = tile.mark
        else
          space = "O"
        end
        print_row += space

      end

      puts print_row
    end

    nil
  end
end

b = Board.new
b.print_board