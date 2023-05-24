require_relative 'pawn'

class Board

    def initialize
        @board = [
            '', 'b', '', 'b', '', 'b', '', 'b',
            'b', '', 'b', '', 'b', '', 'b', '',
            '', 'b', '', 'b', '', 'b', '', 'b',
            '', '', '', '', '', '', '', '',
            '', '', '', '', '', '', '', '',
            'w', '', 'w', '', 'w', '', 'w', '',
            '', 'w', '', 'w', '', 'w', '', 'w',
            'w', '', 'w', '', 'w', '', 'w', ''
        ]

        @pawns = Array.new

        @board.each_with_index{|val, index| if val != ''
            @pawns << Pawn.new(index, val)
        end}
    end

    def square_value(square)
        @board[square]
    end

    def delete_pawn(square)
        @pawns.each{|x| if x.square == square
            x.delete
            @pawns.delete(x)
        end}
        @board[square] = ''
    end

    def select_pawn(square)
        @pawns.each{|x| if x.square == square
            x.select
        end}
    end

    def unselect_pawn(square)
        @pawns.each{|x| if x.square == square
            x.unselect(x.square)
        end}
    end

    def movement(entry, result)
        @board[result] = @board[entry]
        @board[entry] = ''
        @pawns.each{|x|
        if x.square == entry
            x.unselect(result)
        end}
    end

    def pawns(color)
        result = Array.new

        @pawns.each{|x| if x.color == color
            result << x 
        end}

        result
    end
end