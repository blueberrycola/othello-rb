#
# Othello Game Class
# Author(s): Your Name(s)
#

class Othello

    # Constants
    WHITE = 'W'
    BLACK = 'B'
    EMPTY = '-'
    TIE = 'T'

    # Creates getter methods for instance variables @size, @turn, @disc,
    # @p1Disc, and @p2Disc
    attr_reader  :size, :turn, :disc, :p1Disc, :p2Disc

    # Constructs and initializes the board of given size
    def initialize(size, startPlayer, discColor)
        # validate arguments
        if size < 4 || size > 8 || size % 2 != 0
            raise ArgumentError.new('Invalid value for board size.')
        end
        if startPlayer < 1 || startPlayer > 2
            raise ArgumentError.new('Invalid value for player number.')
        end
        if discColor != WHITE && discColor != BLACK
            raise ArgumentError.new('Invalid value for disc.');
        end

        # set instance variables
        @board = []
        @size = size
        @turn = startPlayer
        @disc = discColor

        # set two more instance variables @p1Disc and @p2Disc
        if @turn == 1
            @p1Disc = @disc
            @p2Disc = @disc == WHITE ? BLACK : WHITE
        else
            @p2Disc = @disc
            @p1Disc = @disc == WHITE ? BLACK : WHITE;
        end

        # create the grid (as array of arrays)
        @board = Array.new(@size)
        for i in (0...@board.length)
            @board[i] = Array.new(@size)
            @board[i].fill('-')
        end

        # initialize the grid
        initializeBoard()
    end

    # Initializes the board with start configuration of discs
    def initializeBoard()
        #Init starting board according to size
        @board[@size/2-1][@size/2-1] = BLACK;
        @board[@size/2-1][@size/2] = WHITE;
        @board[@size/2][@size/2-1] = WHITE;
        @board[@size/2][@size/2] = BLACK;

    end
    #Checks a direction given by paramR, paramC
    def check_dir(row, col, disc, paramR, paramC)
        done = false
        r = row + paramR
        c = col + paramC
        while(!done)
            
            if(paramR == 1)
                if(r >= @size)
                    done = true
                    break
                end
            end
            
            if(paramR == -1)
                if(r < 0)
                    done = true
                    break
                end
            end
            
            if(paramC == 1)
                if(c >= @size)
                    done = true
                    break
                end
            end
            
            if(paramC == -1)
                if(c < 0)
                    done = true
                    break
                end
            end
            #check if a matching disc is found after one leap in a direction
            if(@board[r][c] == disc)
                return true
            end

            if(@board[r][c] == EMPTY)
                return false
            end

            r += paramR
            c += paramC
            #Stop condition
            if (paramR >= @size or paramC >= @size)
                done = true
                break
            end
            

        end
        return false
        
    end


    # Returns true if placing the disc of current player at row,col is valid;
    # else returns false
    def isValidMove(row, col)
        return isValidMoveForDisc(row, col, @disc)
    end

    # Returns true if placing the specified disc at row,col is valid;
    # else returns false
    def isValidMoveForDisc(row, col, disc)

        maincheck = false
        #Use check dir for each direction on the grid
        #down check
        if (row - 1 > 0 and @board[row-1][col] != EMPTY and @board[row-1][col] != disc)
            check = check_dir(row, col, disc, -1, 0)
            if(check)
                maincheck = true
            end
        end
        #up check
        if(row-1 > 0 and col + 1 < @size and @board[row-1][col+1] != EMPTY and @board[row-1][col+1] != disc)
            check = check_dir(row,col,disc,-1,1)
            if(check)
                maincheck = true
            end
        end
        
        if(row-1 > 0 and col - 1 > 0 and @board[row-1][col-1] != EMPTY and @board[row-1][col-1] != disc)
            check = check_dir(row,col,disc,-1,-1)
            if(check)
                maincheck = true
            end
        end
        
        if(row + 1 < @size and @board[row+1][col] != EMPTY and @board[row+1][col] != disc)
            check = check_dir(row,col,disc,1,0)
            if(check)
                maincheck = true
            end
        end

        if(row+1 < @size and col-1 > 0 and @board[row+1][col-1] != EMPTY and @board[row+1][col-1] != disc)
            check = check_dir(row,col,disc,1,-1)
            if(check)
                maincheck = true
            end
        end

        if(row+1 < @size and col+1 < @size and @board[row+1][col+1] != EMPTY and @board[row+1][col+1] != disc)
            check = check_dir(row,col,disc,1,1)
            if(check)
                maincheck = true
            end
        end

        if(col-1 > 0 and @board[row][col-1] != EMPTY and @board[row][col-1] != disc)
            check = check_dir(row,col,disc,0,-1)
            if(check)
                maincheck = true
            end
        end

        if(col+1 < @size and @board[row][col+1] != EMPTY and @board[row][col+1] != disc)
            check = check_dir(row,col,disc,0,1)
            if(check)
                maincheck = true
            end
        end

        if(maincheck)
            return true
        end
        # DO NOT DELETE - if control reaches this statement, then it is not a valid move
        return false
    end

    # Places the disc of current player at row,col and flips the
    # opponent discs as needed
    def placeDiscAt(row, col)
        if (!isValidMove(row, col))
            return
        end
        #Check direction to tell if discs need to be flipped
        up_check = check_dir(row,col,@disc,-1,0)
        if(up_check)
            i = row - 1
            while(i > 0)
                if(@board[i][col] == @disc)
                    break
                end

                if(@board[i][col] != @disc and @board[i][col] != EMPTY)
                    @board[i][col] = @disc
                end
                i -= 1
            end
        end
        
        down_check = check_dir(row, col, @disc, 1, 0)
        if(down_check)
            i = row + 1
            while(i < @size)
                if(@board[i][col] == @disc)
                    break
                end
                if(@board[i][col] != @disc and @board[i][col] != EMPTY)
                    @board[i][col] = @disc
                end
                i += 1
            end
        end

        left_check = check_dir(row, col, @disc, 0, -1)
        if(left_check)
            i = col - 1
            while(i > 0)
                if(@board[row][i] == @disc)
                    break
                end
                if(@board[row][i] != @disc and @board[row][i] != EMPTY)
                    @board[row][i] = @disc
                end
                i -= 1
            end
        end

        right_check = check_dir(row,col,@disc,0,1)
        if(right_check)
            i = col + 1
            while(i < @size)
                if(@board[row][i] == @disc)
                    break
                end
                if(@board[row][i] != @disc and @board[row][i] != EMPTY)
                    @board[row][i] = @disc
                end
                i += 1
            end
        end
        
        up_left = check_dir(row,col,@disc,-1,-1)
        if(up_left)
            i = row-1
            j = col-1
            done = false
            while(!done)
                if(i < 0 or j < 0)
                    done = true
                    break
                end
                
                if(@board[i][j] == @disc)
                    break
                end
                
                if(@board[i][j] != @disc and @board[i][j] != EMPTY)
                    @board[i][j] = @disc
                end
                
                i -= 1
                j -= 1

            end
        end
        up_right = check_dir(row, col, @disc, -1, 1)
        if(up_right)
            i = row-1
            j = col+1
            done = false
            while(!done)
                if(i < 0 or j >= @size)
                    done = true
                    break
                end
                if(@board[i][j] == @disc)
                    break
                end
                if(@board[i][j] != @disc and @board[i][j] != EMPTY)
                    @board[i][j] = @disc
                end
                i -= 1
                j += 1
            end
        end

        down_left = check_dir(row, col, @disc, 1, -1)
        
        if(down_left)
            i = row+1
            j = col-1
            done = false
            while(!done)
                if(i >= @size or j < 0)
                    done = true
                    break
                end

                if(@board[i][j] == @disc)
                    done = true
                    break
                end

                if(@board[i][j] != @disc and @board[i][j] != EMPTY)
                    @board[i][j] = @disc
                end
                i += 1
                j -= 1
            end

        end

        down_right = check_dir(row,col,@disc,1,1)
        if(down_right)
            i = row+1
            j = col+1
            done = false
            while(!done)
                if(i >= @size or j >= @size)
                    done = true
                    break
                end

                if(@board[i][j] == @disc)
                    break
                end

                if(@board[i][j] != @disc and @board[i][j] != EMPTY)
                    @board[i][j] = @disc
                end
                i += 1
                j += 1
            end
        end

    



        # place the current player's disc at row,col
        @board[row][col] = @disc

        

        # DO NOT DELETE - prepares for next turn if game is not over
        if (!isGameOver())
            prepareNextTurn();
        end

    end

    # Sets @turn and @disc instance variables for next player
    def prepareNextTurn()
        if @turn == 1
            @turn = 2
        else
            @turn = 1
        end
        if @disc == WHITE
            @disc = BLACK
        else
            @disc = WHITE
        end
    end

    # Returns true if a valid move for current player is available;
    # else returns false
    def isValidMoveAvailable()
        isValidMoveAvailableForDisc(@disc)
    end

    # Returns true if a valid move for the specified disc is available;
    # else returns false
    def isValidMoveAvailableForDisc(disc)
        valid = false
        i = 0
        while(i < @size)
            j = 0
            while(j < @size)
                if(@board[i][j] == EMPTY)
                    if(isValidMove(i,j))
                        valid = true
                    end
                end
                j += 1
            end
            i += 1
        end

        if(valid)
            return true
        end
        
        # DO NOT DELETE - if control reaches this statement, then a valid move is not available
        return false;
    end

    # Returns true if the board is fully occupied with discs; else returns false
    def isBoardFull()
        i = 0
        while(i < @size)
            j = 0
            while(j < @size)
                if(@board[i][j] == EMPTY)
                    return false
                end
                j += 1
            end
            i += 1
        end

        return true;
    end

    # Returns true if either the board is full or a valid move is not available
    # for either disc
    def isGameOver()
        return isBoardFull() ||
                    (!isValidMoveAvailableForDisc(WHITE) &&
                                !isValidMoveAvailableForDisc(BLACK))
    end

    # If there is a winner, it returns Othello::WHITE or Othello::BLACK.
    # In case of a tie, it returns Othello::TIE
    def checkWinner()
        whitetot = 0
        blacktot = 0
        i = 0
        while(i < @size)
            j = 0
            while(j < @size)
                if(@board[i][j] == BLACK)
                    blacktot += 1
                end
                if(@board[i][j] == WHITE)
                    whitetot += 1
                end

                j += 1
            end
            i += 1
        end
        if (whitetot < blacktot)
            return BLACK
        elsif (blacktot < whitetot)
            return WHITE
        else
            return TIE
        end

        

    end

    # Returns a string representation of the board
    def to_s()
        str = "\n  "
        for i in (0...@size)
            str << (i+1).to_s + ' '
        end
        str << "\n";
        for i in (0...@size)
            str << (i+1).to_s + ' ';
            str << @board[i].join(' ') + "\n";
        end
        return str;
    end

end
