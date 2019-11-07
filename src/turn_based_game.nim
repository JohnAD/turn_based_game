# turn_based_game
# Copyright 2018 John Dupuy
# MIT License
# Game rules framework for turn-based games

import strutils
import tables

## This framework encapsulates the critical information (rules) needed for
## playing or simulating a turn-based game.
##
## Some common turn-based games: Checkers, Reversi, Chess, Stratego,
## Connect 4.
##
## Usage
## =====
##
## To use, simply:
## 
## 1. Define a game object that inherits from ``Game``.
## 2. Add the game rules as methods for ``setup``, ``set_possible_moves``,
##    ``make_move``, and ``determine_winner``. You can override additional
##    methods for more rule changes. And, you can add new ones. But the basic
##    four are the minimum for enabling a game.
## 3. Invoke your new object and pass in a list of player objects. (Or, AI
##    objects if using an AI library.)
## 4. Run the new object's ``setup`` method. This resets the game.
##
## And, when running from a terminal,
#
## 5. Run the new object's ``play`` method
##
## Quick Example
## =============
##
## .. code:: nim
##
##     #
##     # Game of Thai 21 example
##     #
##     # Description: Twenty one flags are placed on a beach. Each player takes a turn
##     # removing between 1 and 3 flags. The player that removes the last remaining flag wins.
##     #
##     # This game was introduced by an episode of Survivor: http://survivor-org.wikia.com/wiki/21_Flags
##     #
##
##     import strutils
##     import turn_based_game
##     import tables
##
##     #
##     # 1. define our game object
##     #
##
##     type
##       GameOfThai21 = ref object of Game
##         pile*: int
##
##     #
##     #  2. add our rules (methods)
##     #
##
##     method setup*(self: GameOfThai21, players: seq[Player]) =
##       self.default_setup(players)
##       self.pile = 21
##
##     method set_possible_moves(self: GameOfThai21, moves: var OrderedTable[string, string]) =
##       if self.pile==1:
##         moves = {"1": "Take One"}.toOrderedTable
##       elif self.pile==2:
##         moves = {"1": "Take One", "2": "Take Two"}.toOrderedTable
##       else:
##         moves = {"1": "Take One", "2": "Take Two", "3": "Take Three"}.toOrderedTable
##
##     method make_move(self: GameOfThai21, move: string): string =
##       var count = move.parseInt()
##       self.pile -= count  # remove bones.
##       return "$# flags removed.".format([count])
##
##     method determine_winner(self: GameOfThai21) =
##       if self.winner_player_number > 0:
##         return
##       if self.pile <= 0:
##         self.winner_player_number = self.current_player_number
##
##     # the following method is not _required_, but makes it nicer to read
##     method status(self: GameOfThai21): string =
##       "$# flags available.".format([self.pile])
##
##     #
##     # 3. invoke the new game object
##     #
##
##     var game = GameOfThai21()
##
##     #
##     # 4. reset (start) a new game with, in this case, 3 players
##     #
##
##     game.setup(@[Player(name: "A"), Player(name: "B"), Player(name: "C")])
##
##     #
##     # 5. play the game at a terminal
##     #
##
##     game.play()
##
## Documentation
## =============
##
## Greater documentation is being built at the wiki on this repository.
##
## Visit https://github.com/JohnAD/turn_based_game/wiki
##
## Videos
## ======
##
## The following two videos (to be watched in order), demonstrate how to
## use this library and the 'turn\_based\_game' library:
##
## 1. Using "turn\_based\_game":
##    https://www.youtube.com/watch?v=u6w8vT-oBjE
## 2. Using "negamax": https://www.youtube.com/watch?v=op4Mcgszshk
##
## Credit
## ======
##
## The code for this engine mimics that written in Python at the EasyAI
## library located at https://github.com/Zulko/easyAI. That library
## contains both the game rule engine (called TwoPlayerGame) as well as a
## variety of AI algorithms to play as game players, such as Negamax.


# #######################################
# 
#   Type Definitions
# 
# ######################################

type

  Game* = ref object of RootObj
    ## The game object to inherit from and then apply rules.
    ## 
    ## For example:
    ## 
    ##
    ## .. code:: nim
    ##
    ##     type
    ##       GameOfThai21 = ref object of Game
    ##         pile*: int
    ##
    player_count*: int
    players*: seq[Player]
    current_player_number*: int  # 1, 2, 3,... but 0 is never used
    winner_player_number*: int   # 0=no winner; -1=stalemate; n=winner

  Player* = ref object of RootObj
    ## The default player object. If used directly, the Player object
    ## is simply the end user playing the game from the OS's text console.
    ## 
    ## When integrating with another framework, such as a GUI or an AI, 
    ## have the framework's player inherit from Player.
    name*: string

const
  STALEMATE* = -1
  NO_WINNER_YET* = 0
  TAB: string = "   "


# the following prototypes are needed to allow mutual recursion of methods
#   It is properly defined later.
# method possible_moves_seq*(self: Game): seq[string] {.base.}
method set_possible_moves*(self: Game, moves: var OrderedTable[string, string]) {.base.}  #SKIP!
method set_possible_moves*(self: Game, moves: var seq[string]) {.base.}  #SKIP!
method status*(self: Game): string {.base.}  #SKIP!

# ######################################
#
#  Player
# 
# ######################################


method display(self: Player, msg: string) {.base.} =
    echo $msg


method get_move*(self: Player, game: Game): string {.base.} = 
  var move_list: seq[string] = @[]
  var descriptive_move_list: OrderedTable[string, string]
  var compact_description: bool = false
  echo ""
  echo TAB & "Status:"
  echo indent(game.status(), 2, TAB)
  game.set_possible_moves(move_list)
  if len(move_list) > 0:
    compact_description = true
  else:
    game.set_possible_moves(descriptive_move_list)
    for key, value in descriptive_move_list.pairs():
      move_list.add(key)
  while true:
    echo TAB & "Possible moves:"
    if compact_description:
      var disp = TAB & TAB
      for key in move_list:
        disp.add("[$#] ".format(key))
      echo disp
    else:
      for key, value in descriptive_move_list.pairs():
        echo TAB & TAB & "[$key]: $value".format("key", key, "value", value)
    echo TAB & "Enter move (or 'quit'): "
    var response: string
    when defined(js):
      # for some reason, generating a raise does not work.
      response = "When compiling for Javascript, you cannot use this procedure."
    else:
      response = readLine(stdin)
    if response in move_list:
      return response
    if response == "quit":
      return ""
    echo TAB & "BAD ENTRY. Try again."

# ######################################
#
#  Game
# 
# ######################################


method set_possible_moves*(self: Game, moves: var seq[string]) {.base.} =
  ## Set the current possible moves of the game.
  ## See https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#set_possible_moves
  moves = @[]


method set_possible_moves*(self: Game, moves: var OrderedTable[string, string]) {.base.} =
  ## Set the current possible moves of the game.
  ## See https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#set_possible_moves
  raise newException(FieldError, "set_possible_moves(OrderedTable) must be overridden")


method current_player*(self: Game) : Player {.base.} =
  ## Return the Player whose turn it is to play
  self.players[self.current_player_number - 1]


method winning_player*(self: Game) : Player {.base.} =
  ## Return the Player who is the winner.
  ## If there is no winner, a "false" Player is returned with the name
  ## "NO WINNER YET" or "STALEMATE OR TIE"
  if self.winner_player_number > NO_WINNER_YET:
    return self.players[self.winner_player_number - 1]
  elif self.winner_player_number == NO_WINNER_YET:
    return Player(name: "NO WINNER YET")
  else:
    return Player(name: "STALEMATE OR TIE")


method next_player_number*(self: Game): int {.base.} =
  ## Return the number to the next player.
  (self.current_player_number %% self.player_count) + 1


method finish_turn*(self: Game) {.base.} =
  ## Cleanup anything in the current turn and start the next turn.
  ## 
  ## By default, this simply changes the player number. Override this method
  ## if the game needs more to happen.
  self.current_player_number = self.next_player_number()


method make_move*(self: Game, move: string): string {.base.} =
  ## Given a move (from ``set_possible_moves``), apply that move
  ## to the game.
  ## 
  ## This is where most of the rules of the game are coded. This method
  ## MUST be overridden.
  ## 
  ## See: https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#make_move
  raise newException(FieldError, "make_move() must be overridden")


method is_over*(self: Game): bool {.base.} =
  ## Return whether or not the game is over.
  self.winner_player_number != NO_WINNER_YET


method status*(self: Game): string {.base.} =
  ## Return a status of the game overrall. By default, it simply returns either
  ## "game is over" or "game is active". Override this method for something
  ## more sophisticated.
  if self.is_over():
    return "game is over"
  else:
    return "game is active"


method determine_winner*(self: Game) {.base.} =
  ## Given the current state of the game, determine who the winner is, if there
  ## is a winner.
  ## 
  ## If running a game manually (avoiding the .play method), it is expected that
  ## this method is run BEFORE the turn finishes. If a winning condition is detected,
  ## the current player is generally assumed to be the winner that caused that
  ## condition.
  ## 
  ## See: https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#determine_winner
  raise newException(FieldError, "determine_winner() must be overridden")


method scoring*(self: Game): float {.base.} =
  ## Return a score reflecting the advantage to the current player.
  ## 
  ## This method is not actually used by this library; but is used by some
  ## external AI libraries.
  raise newException(FieldError, "scoring() must be overridden (if used)")


method get_state*(self: Game): string {.base.} =
  ## Returns a string that is encoded to represent the current game, including who
  ## the current player is.
  ## 
  ## This method is not actually used by this library; but is used by some
  ## external AI libraries.
  raise newException(FieldError, "get_state() must be overridden (if used)")


method restore_state*(self: Game, state: string): void  {.base.} =
  ## Decodes the string to reset the game to the state encoded in the string.
  ## 
  ## This method is not actually used by this library; but is used by some
  ## external AI libraries.
  raise newException(FieldError, "restore_state() must be overridden (if used)")


method setup*(self: Game, players: seq[Player]) {.base.} =
  ## Setup the board; resetting all state for a new game.
  ## 
  ## See https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#setup
  raise newException(FieldError, "setup() must be overridden")


method default_setup*(self: Game, players: seq[Player]) {.base.} =
  ## This is the default setup for Game. You are welcome to call it when writing
  ## the ``setup`` method.
  ## 
  ## The code is:
  ## 
  ## .. code:: nim
  ## 
  ##     self.players = players
  ##     self.player_count = len(self.players)
  ##     self.current_player_number = 1
  ##     self.winner_player_number = 0

  self.players = players
  self.player_count = len(self.players)
  self.current_player_number = 1
  self.winner_player_number = 0


method play*(self: Game) : seq[string] {.base discardable.} = 
  ## Start and run the game. Unless this method is overriden, this plays
  ## the game from the text console.
  result = @[]
  var move: string = ""
  while not self.is_over():
    self.current_player.display("-----------------")
    self.current_player.display("$1's Turn".format(self.current_player.name))
    move = self.current_player.get_move(self)
    if move == "":
      break
    self.current_player.display("")
    self.current_player.display("$1 chose \"$2\"".format(self.current_player.name, move))
    result.add(move)
    self.current_player.display("")
    self.current_player.display(TAB & self.make_move(move))
    self.determine_winner()
    if self.is_over():
      self.current_player.display("")
      if self.winner_player_number == STALEMATE:
        self.current_player.display("STALEMATE.")
      else:
        self.current_player.display("WINNER IS $#".format([self.winning_player.name]))
      break
    self.current_player_number = self.next_player_number()
