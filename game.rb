require_relative 'board'
require_relative 'pawn'

class Game

    def initialize
        @board = Board.new
        @turn = 'w'
        @selected = false
        @can_beat = false
        @can_change = true
    end
  
    def event(x, y)
        x = (x - 25) / 100
        y = (y - 25) / 100
        square = x + 8 * y

        if square >= 0 && square < 64 && @board.square_value(square) == @turn && @can_change
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
        if check_beat(@selected, square)
            beat(square)
        elsif @can_beat == false && @can_change
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
            @board.movement(@selected, square, true)
            check_promotion(square)
            @selected = false
            change_turn 
        else
            @board.unselect_pawn(@selected)
            @selected = false
        end
    end

    def check_promotion(square)
        case @turn
        when 'w'
            if square / 8 == 0 then @board.promote(square) end
        when 'b'
            if square / 8 == 7 then @board.promote(square) end
        end
    end


    def check_beat(square, check_square)
        right = [14, -18]
        left = [18, -14]
        question = false

        if check_square >= 0 and check_square < 64
            case square % 8
            when 0..1
                right.each{ |x| question ||= beating_conditions(square, check_square, x)}
            when 2..5
                right.each{ |x| question ||= beating_conditions(square, check_square, x)}
                left.each{ |x| question ||= beating_conditions(square, check_square, x)}
            when 6..7
                left.each{ |x| question ||= beating_conditions(square, check_square, x)}
            end
        end

        question
    end

    def beating_conditions(square, check_square, x)
        if check_square + x >= 0 && check_square + x < 64
            (square == check_square + x and @board.square_value(check_square) == '' and
            @board.square_value(check_square + x/2) != '' and @board.square_value(check_square + x/2) != @turn)
        else false end
    end

    def beat(square)
        rest = @selected % 8
        sq_rest = square % 8
        unselect = !check_possible_beatings(square)

        if square < @selected
            beated_pawn = @selected - (8 + (rest - sq_rest) / 2)
        else
            beated_pawn = @selected + (8 + (sq_rest - rest) / 2)
        end

        @board.movement(@selected, square, unselect)
        @board.delete_pawn(beated_pawn)
        @selected = square

        if !unselect
            @can_change = false
        else
            check_promotion(square)
            @can_change = true
            @selected = false
            change_turn
        end
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