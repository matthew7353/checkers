require 'ruby2d'

class Pawn
    def initialize(square, color)
        @square = square
        @color = color
        @queen = false
        case @color
        when 'w'
            @pawn = Image.new(
            'images/white.jpg',
            x: count_x(@square), y: count_y(square)
            )
        when 'b'
            @pawn = Image.new(
                'images/black.jpg',
                x: count_x(@square), y: count_y(square)
                )
        end
    end

    def count_x(square)
        (square % 8 * 100 + 25)
    end

    def count_y(square)
        (square / 8 * 100 + 25)
    end

    def queen
        @queen
    end

    def square
        @square
    end

    def delete
        @pawn.remove
    end

    def color
        @color
    end

    def promote
        @queen = true
    end

    def select
        if @color == 'w'
            @selected_pawn = Image.new(
                'images/white_selected.jpg',
                x: @pawn.x, y: @pawn.y
            )
        else
            @selected_pawn = Image.new(
                'images/black_selected.jpg',
                x: @pawn.x, y: @pawn.y
            )
        end
        @pawn.remove
    end

    def unselect(square)
        @square = square
        if @color == 'w'
            @pawn = Image.new(
                'images/white.jpg',
                x: count_x(@square), y: count_y(@square)
            )
        else
            @pawn = Image.new(
                'images/black.jpg',
                x: count_x(@square), y: count_y(@square)
            )
        end
        @selected_pawn.remove
    end
end

