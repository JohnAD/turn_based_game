Introduction to turn_based_game
==============================================================================
ver 1.1.6

This framework encapsulates the critical information (rules) needed for
playing or simulating a turn-based game.

Some common turn-based games: Checkers, Reversi, Chess, Stratego,
Connect 4.

Usage
=====

To use, simply:

1. Define a game object that inherits from ``Game``.
2. Add the game rules as methods for ``setup``, ``set_possible_moves``,
   ``make_move``, and ``determine_winner``. You can override additional
   methods for more rule changes. And, you can add new ones. But the basic
   four are the minimum for enabling a game.
3. Invoke your new object and pass in a list of player objects. (Or, AI
   objects if using an AI library.)
4. Run the new object's ``setup`` method. This resets the game.

And, when running from a terminal,
5. Run the new object's ``play`` method

Quick Example
=============

.. code:: nim

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

Documentation
=============

Greater documentation is being built at the wiki on this repository.

Visit https://github.com/JohnAD/turn_based_game/wiki

Videos
======

The following two videos (to be watched in order), demonstrate how to
use this library and the 'turn\_based\_game' library:

1. Using "turn\_based\_game":
   https://www.youtube.com/watch?v=u6w8vT-oBjE
2. Using "negamax": https://www.youtube.com/watch?v=op4Mcgszshk

Credit
======

The code for this engine mimics that written in Python at the EasyAI
library located at https://github.com/Zulko/easyAI. That library
contains both the game rule engine (called TwoPlayerGame) as well as a
variety of AI algorithms to play as game players, such as Negamax.



Table Of Contents
=================

1. `Introduction to turn_based_game <https://github.com/JohnAD/turn_based_game>`__
2. Appendices

    A. `turn_based_game Reference <turn_based_game-ref.rst>`__
