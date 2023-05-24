require_relative 'board'
require_relative 'pawn'

class Game

    def initialize
        @board = Board.new
        @turn = 'w'
        @selected = false
        @can_beat = false
    end
  
    def event(x, y)
        x = (x - 25) / 100
        y = (y - 25) / 100
        square = x + 8 * y

        if square >= 0 and square < 64 and @board.square_value(square) == @turn
            if @selected
                @board.unselect_pawn(@selected)
                @selected = false
            end
            @selected = square
            @board.select_pawn(square)
        elsif @selected
            movement(square)
        end
    end

    def movement(square)
        if check_beat(@selected ,square)
            beat(square)
        elsif @can_beat == false
            check_move(square)
        end
    end

    def change_turn
        if @turn == 'w' then @turn = 'b'
        else @turn = 'w' end
        
        pawns = @board.pawns(@turn)
        @can_beat = false

        pawns.each{ |x| @can_beat ||= check_possible_beatings(x.square) }
    end

    def check_move(square)
        rest = @selected % 8
        sq_rest = square % 8
        div = @selected / 8
        sq_div = square / 8

        question = ((rest == sq_rest - 1) or (rest == sq_rest + 1))
        
        if @turn == 'w'
            question &&= (div == sq_div + 1)
        else
            question &&= (div + 1 == sq_div)
        end
        
        if question and @board.square_value(square) == ''
            @board.movement(@selected, square)
            @selected = false
            change_turn 
        else
            @board.unselect_pawn(@selected)
            @selected = false
        end
    end

    def check_beat(square, check_square)
        right = [14, -18]
        left = [18, -14]
        question = false

        case square % 8
        when 0..1
            right.each{ |x| if check_square + x >= 0 && check_square + x < 64
                question ||= (square == check_square + x and @board.square_value(check_square) == '' and
                @board.square_value(check_square + x/2) != '' and @board.square_value(check_square + x/2) != @turn)
            end}
        when 2..5
            right.each{ |x| if check_square + x >= 0 && check_square + x < 64
                question ||= (square == check_square + x and @board.square_value(check_square) == '' and
                @board.square_value(check_square + x/2) != '' and @board.square_value(check_square + x/2) != @turn)
            end}
            left.each{ |x| if check_square + x >= 0 && check_square + x < 64
                question ||= (square == check_square + x and @board.square_value(check_square) == '' and
                @board.square_value(check_square + x/2) != '' and @board.square_value(check_square + x/2) != @turn)
            end}
        when 6..7
            left.each{ |x| if check_square + x >= 0 && check_square + x < 64
                question ||= (square == check_square + x and @board.square_value(check_square) == '' and
                @board.square_value(check_square + x/2) != '' and @board.square_value(check_square + x/2) != @turn)
            end}
        end

        question
    end

    def beat(square)
        rest = @selected % 8
        sq_rest = square % 8

        if square < @selected
            beated_pawn = @selected - (8 + (rest - sq_rest) / 2)
        else
            beated_pawn = @selected + (8 + (sq_rest - rest) / 2)
        end

        @board.movement(@selected, square)
        @board.delete_pawn(beated_pawn)
        @selected = false
        change_turn
    end
    
    def check_possible_beatings(square)
        question = false

        case square % 8
        when 0..1
            question ||= (check_beat(square, square - 14) || check_beat(square, square + 18))
        when 2..5
            question ||= (check_beat(square, square - 14) || check_beat(square, square + 18))
            question ||= (check_beat(square, square - 18) || check_beat(square, square + 14))
        when 6..7
            question ||= (check_beat(square, square - 18) || check_beat(square, square + 14))
        end

        question
    end
end