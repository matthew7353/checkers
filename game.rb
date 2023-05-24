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
        if check_beat(square)
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

        pawns.each{|x| @selected = x.square
            case x.square % 8
            when 0..1
                @can_beat ||= (check_beat(@selected - 14) || check_beat(@selected + 18))
            when 2..5
                @can_beat ||= (check_beat(@selected - 14) || check_beat(@selected + 18))
                @can_beat ||= (check_beat(@selected - 18) || check_beat(@selected + 14))
            when 6..7
                @can_beat ||= (check_beat(@selected - 18) || check_beat(@selected + 14))
            end
        }

        @selected = false
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

    def check_beat(square)
        right = [14, -18]
        left = [18, -14]
        question = false

        if square >= 0 and square < 64
            case @selected % 8
            when 0..1
                right.each{ |x| if square + x >= 0 && square + x < 64
                    question ||= (@selected == square + x and @board.square_value(square) == '' and
                    @board.square_value(square + x/2) != '' and @board.square_value(square + x/2) != @turn)
                end}
            when 2..5
                right.each{ |x| if square + x >= 0 && square + x < 64
                    question ||= (@selected == square + x and @board.square_value(square) == '' and
                    @board.square_value(square + x/2) != '' and @board.square_value(square + x/2) != @turn)
                end}
                left.each{ |x| if square + x >= 0 && square + x < 64
                    question ||= (@selected == square + x and @board.square_value(square) == '' and
                    @board.square_value(square + x/2) != '' and @board.square_value(square + x/2) != @turn)
                end}
            when 6..7
                left.each{ |x| if square + x >= 0 && square + x < 64
                    question ||= (@selected == square + x and @board.square_value(square) == '' and
                    @board.square_value(square + x/2) != '' and @board.square_value(square + x/2) != @turn)
                end}
            end
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
end