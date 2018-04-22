# game of bones example
#
from turn_based_game import Game, Human_Player_Console

type
  GameOfBones ref object of Game



# Start a match
game = GameOfBones( [ Human_Player_Console, Human_Player_Console ] )
history = game.play()
