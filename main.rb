require 'ruby2d'

require_relative 'game'


board = Image.new('PO/projekt/images/board.jpg')
set width: 850
set height: 850
set resizable: true

game = Game.new

on :mouse_down do |event|
  game.event(event.x, event.y)  
end
  
show