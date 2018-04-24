# *turn_based_game* Framework

This framework encapsulates the critical information (rules) needed for playing or simulating a turn-based game.

A turn-based game is any game with:

* two or more players
* only one player plays at a time
* the players take turns playing (it need not be round-robin, but that is the most common method)

This library also assumes:

* all the players are playing by the same rules
* a single "move" is made for each player's turn
    * it can be complex set of actions involving many pieces, but a single _choice_ is made for that complex set
    * the game can be written to allow "skip turn" as a valid "move"
* the player's turn is over after the move is made and applied

Some common turn-based games: Checkers, Reversi, Chess, Stratego, Connect 4.

# Usage

To use, simply:
1. Define a game object that inherits from `Game`
2. Add the game rules as methods for `setup`, `possible_moves`, `make_move`, and `determine_winner`. You can override additional methods for more rule changes. And, you can add new ones. But the basic four are the minimum for enabling a game.
3. Invoke your new object and pass in a list of player objects. (Or, AI objects if using an AI library.)
4. Run the new object's `setup` method. This resets the game.

And, when running from a terminal,

5. Run the new object's `play` method.

# Quick Example

```
#
# Game of Thai 21 example
#
# decription: Twenty one flags are placed on a beach. Each player takes a turn
# removing between 1 and 3 flags. The player that removes the last remaining flag wins.
#
# this game was introduced by an episode of Survivor: http://survivor-org.wikia.com/wiki/21_Flags
#

import strutils
import turn_based_game

#
# 1. define our game object
#

type
  GameOfThai21 = ref object of Game
    pile*: int

#
#  2. add our rules (methods)
#

method setup*(self: GameOfThai21, players: seq[GenericPlayer]) =
  self.default_setup(players)
  self.pile = 21

method possible_moves(self: GameOfThai21): seq[string] =
  var limit = 2
  if self.pile < 3:
    limit = self.pile - 1
  @["1", "2", "3"][0..limit]

method make_move(self: GameOfThai21, move: string): string =
  var count = move.parseInt()
  self.pile -= count  # remove bones.
  self.determine_winner()
  return "$# flags removed.".format([count])

method determine_winner(self: GameOfThai21) =
  if self.winner_player_number > 0:
    return
  if self.pile <= 0:
    self.winner_player_number = self.current_player_number
  return

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
```
