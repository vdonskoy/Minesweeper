require 'yaml'
class Tile
  attr_accessor :board, :coords, :bombed, :revealed, :flagged, :mark

  def initialize(board)
    @bombed = rand(10) < 1 ? true : false
    @revealed = false
    @flagged = false
    @coords = [0,0]
    @board = board
    @mark = "❑"
  end

  def reveal
    return "⚑" if self.flagged
    @revealed = true
    bombs_nearby = self.neighbor_bomb_count

    return @mark = "☭" if self.bombed

    if bombs_nearby == 0
      @mark = " "
      neighbors.each do |neighbor|
        neighbor_tile = @board.board[neighbor[0]][neighbor[1]]
        neighbor_tile.reveal if neighbor_tile.revealed == false
      end
    else
      @mark = bombs_nearby.to_s
    end
  end

  def flag
    @flagged = (@flagged == false ? true : false)
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
    9.times do |i|
      @board << []
      9.times do |j|
        @board[i][j] = Tile.new(self)
        @board[i][j].coords = [i,j]
      end
    end
  end

  def print_board

    @board.each do |row|
      print_row = ""

      row.each do |tile|
        if tile.flagged
          space = "⚑"
        elsif tile.revealed
          space = tile.mark
        else
          space = "❑"
        end
        print_row += space

      end

      puts print_row
    end

    nil
  end


  def play

    print_board

    until game_over?

      puts "Where do you want to look? (r - reveal, f - flag ... example: r12)"

      input = gets.chomp.split("")

      if input[0] == "r"
        @board[input[1].to_i][input[2].to_i].reveal
        if @board[input[1].to_i][input[2].to_i].bombed
          print_board
          puts "You lost!"
          break
        end
      elsif input[0] == "f"
        @board[input[1].to_i][input[2].to_i].flag
      elsif input.join("") == "save"
        self.save
        puts "saved"
      end

      print_board
    end

  end

  def save
    File.open("Minesweeper_save.yml", "w") do |f|
      f.puts self.to_yaml
    end
  end

  def self.load
    YAML.load(File.read("Minesweeper_save.yml"))
  end

  def game_over?
    @board.each do |row|
      row.each do |tile|
        return false if tile.revealed == false && !tile.bombed
      end
    end

    puts "You won!"
    return true
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "New game or Load game?"
  answer = gets.chomp
  if answer == "new"
    Board.new.play
  elsif answer == "load"
    Board.load.play
  end
end