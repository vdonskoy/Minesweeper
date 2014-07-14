class Tile
  attr_accessor :coords, :bombed, :revealed, :flagged

  def initialize
    @bombed = rand(10) < 2 ? true : false
    @revealed = false
    @flagged = false
    @coords = [0,0]
  end

  def reveal
    @revealed = true
  end

  def flag
    @flagged = true
  end

  def mark
    bombs_nearby = self.neighbor_bomb_count

    if bombs_nearby == 0
      mark = "_"
      neighbors.each { |neighbor| neighbor.reveal }
    else
      mark = bombs_nearby
    end

    mark
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
      if neighbor.bombed
        bombs_nearby += 1
      end
    end

    bombs_nearby
  end
end

class Board
  def initialize
    @board = []
    i = 0
    while i < 9
      j = 0
      @board << []
      while j < 9
        @board[i][j] = Tile.new
        @board[i][j].coords = [i,j]
        j += 1
      end
      i += 1
    end

    print_board
  end

  def print_board
    @board.each do |row|
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

      p print_row
    end
  end
end