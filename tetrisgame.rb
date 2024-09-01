class MyPiece < Piece

  All_My_Pieces = All_Pieces
  
  All_My_Pieces.append(rotations([[0, 0], [-1, 0], [1, 0], [-2, 0], [2, 0]]))  # 5 long
  All_My_Pieces.append(rotations([[0, 0], [1, 0], [0, 1]]))# Triangle L
  All_My_Pieces.append(rotations([[0, 0], [1, 0], [0, 1], [1, 1], [2, 0]])) #weird 5 piece

  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

end


class MyBoard < Board

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size - 1)).each{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end


  def rotate180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  def cheated? #flag for cheating
    @cheated
  end

  def cheaterHelper
    if !game_over? and @game.is_running?
      if @score > 100 and !@cheated
        @cheated = true
        @score -= 100
      end
    end
  end

  def next_piece
    if @cheated
      @cheated = false
      @current_block = MyPiece.new([[[0, 0]]], self)
      @current_pos = nil
    else
      super
    end
  end



  

  

end

class MyTetris < Tetris
  # your enhancements here

  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self) #MyBoard.new instead of board
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    @root.bind('u', proc {@board.rotate180})
    @root.bind('c', proc {@board.cheaterHelper})
    super
  end
end

class MyPieceChallenge < MyPiece


end

class MyBoardChallenge < MyBoard

  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = Piece.next_piece(self)
    @score = 0
    @game = game
    @delay = 300
  end

  def ifPlaced?
    @ifPlaced
  end

  def store_current
  @ifPlaced = false
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size - 1)).each{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    @ifPlaced = true
    remove_filled
    counterDelayChecker
  end

  def counterDelayChecker
    if !game_over? and @game.is_running?
      if ifPlaced?
        @delay = [@delay - 10, 20].max
      end
    end
  end

  def remove_filled
    (2..(@grid.size-1)).each{|num| row = @grid.slice(num);
      # see if this row is full (has no nil)
      if @grid[num].all?
        removedCheckerHelper
        # remove from canvas blocks in full row
        (0..(num_columns-1)).each{|index|
          @grid[num][index].remove;
          @grid[num][index] = nil
        }
        
        # move down all rows above and move their blocks on the canvas
        ((@grid.size - num + 1)..(@grid.size)).each{|num2|
          @grid[@grid.size - num2].each{|rect| rect && rect.move(0, block_size)};
          @grid[@grid.size-num2+1] = Array.new(@grid[@grid.size - num2])
        }
        # insert new blank row at top
        @grid[0] = Array.new(num_columns);
        # adjust score for full flow
        @score += 10;
      end}
    self
  end


  def removedCheckerHelper
    if !game_over? and @game.is_running?
        @delay = 300
    end
  end

  def randomizer
    @current_block = MyPieceChallengePiece.next_piece(self)
  end

end

class MyTetrisChallenge < MyTetris
  def initialize
    @root = TetrisRoot.new
    @timer = TetrisTimer.new
    set_board
    @running = true
    key_bindings
    buttons
    run_game
  end



  def set_board #DONT REMOVE
    @canvas = MyTetrisCanvas.new
    
    @board = MyBoardChallenge.new(self)
    
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    
    @board.draw
  end

  #def buttons
    #testing = TetrisButton.new('testButton', 'black'){self.testing}
      #testing.place(50, 75, 230, 300) #first two are size height and width, second is x and y
    #super
  #end

end


#def key_bindings #not working
  #super
  #@root.bind('b' , proc {@board.quickMove})
#end

#Shift_R for right shift

class MyTetrisCanvas < TetrisCanvas

  #def initialize
    #super
    #@newcanvas = TkCanvas.new('background' => 'green')
  #end

  #def newCanvas
    #@newcanvas
  #end

  #def place(height, width, x, y)
   # super
    #@newcanvas.place('height' => 100, 'width' => 100, 'x' => 200, 'y' => 120)
  #end
end