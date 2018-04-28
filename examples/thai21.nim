#
# Game of Thai 21 example
#
# Description: Twenty one flags are placed on a beach. Each player takes a turn
# removing between 1 and 3 flags. The player that removes the last remaining flag wins.
#
# This game was introduced by an episode of Survivor: http://survivor-org.wikia.com/wiki/21_Flags
#

import strutils
import turn_based_game
import tables

#
# 1. define our game object
#

type
  GameOfThai21 = ref object of Game
    pile*: int

#
#  2. add our rules (methods)
#

method setup*(self: GameOfThai21, players: seq[Player]) =
  self.default_setup(players)
  self.pile = 21

method set_possible_moves(self: GameOfThai21, moves: var OrderedTable[string, string]) =
  if self.pile==1:
    moves = {"1": "Take One"}.toOrderedTable
  elif self.pile==2:
    moves = {"1": "Take One", "2": "Take Two"}.toOrderedTable
  else:
    moves = {"1": "Take One", "2": "Take Two", "3": "Take Three"}.toOrderedTable

method make_move(self: GameOfThai21, move: string): string =
  var count = move.parseInt()
  self.pile -= count  # remove bones.
  return "$# flags removed.".format([count])

method determine_winner(self: GameOfThai21) =
  if self.winner_player_number > 0:
    return
  if self.pile <= 0:
    self.winner_player_number = self.current_player_number

# the following method is not _required_, but makes it nicer to read
method status(self: GameOfThai21): string =
  "$# flags available.".format([self.pile])

#
# 3. invoke the new game object
#

var game = GameOfThai21()

#
# 4. reset (start) a new game with, in this case, 3 players
#

game.setup(@[Player(name: "A"), Player(name: "B"), Player(name: "C")])

#
# 5. play the game at a terminal
#

game.play()