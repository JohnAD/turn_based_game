# turn_based_game
# Copyright John Dupuy
# Game rules framework for turn-based games

import strutils
import tables

## #######################################
## 
##   Type Definitions
## 
## ######################################

type

  Game* = ref object of RootObj
    player_count*: int
    players*: seq[Player]
    current_player_number*: int
    winner_player_number*: int

  Player* = ref object of RootObj
    name*: string

const
  STALEMATE* = -1
  NO_WINNER_YET* = 0
  TAB: string = "   "


# the following prototypes are needed to allow mutual recursion of methods
#   It is properly defined later.
# method possible_moves_seq*(self: Game): seq[string] {.base.}
method set_possible_moves*(self: Game, moves: var OrderedTable[string, string]) {.base.}
method set_possible_moves*(self: Game, moves: var seq[string]) {.base.}
method status*(self: Game): string {.base.}

## ######################################
## 
##   Player
## 
## ######################################


method display(self: Player, msg: string) {.base.} =
    echo $msg


method get_move(self: Player, game: Game): string {.base.} = 
  var move_list: seq[string] = @[]
  var descriptive_move_list: OrderedTable[string, string]
  var compact_description: bool = false
  echo ""
  echo "$#'s TURN".format([self.name])
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
    stdout.write TAB & "Enter move (or 'quit'): "
    var response = readLine(stdin)
    if response in move_list:
      return response
    if response == "quit":
      return nil
    echo TAB & "BAD ENTRY. Try again."

## ######################################
## 
##   Game
## 
## ######################################


method set_possible_moves*(self: Game, moves: var seq[string]) {.base.} =
  moves = @[]


method set_possible_moves*(self: Game, moves: var OrderedTable[string, string]) {.base.} =
  raise newException(FieldError, "possible_moves() must be overridden")


method current_player*(self: Game) : Player {.base.} =
  self.players[self.current_player_number - 1]


method winning_player*(self: Game) : Player {.base.} =
  self.players[self.winner_player_number - 1]


method next_player_number*(self: Game): int {.base.} =
  (self.current_player_number %% self.player_count) + 1


method finish_turn*(self: Game) {.base.} =
  self.current_player_number = self.next_player_number()


method make_move*(self: Game, move: string): string {.base.} =
  raise newException(FieldError, "make_move() must be overridden")


method is_over*(self: Game): bool {.base.} =
  self.winner_player_number != NO_WINNER_YET


method status*(self: Game): string {.base.} =
  if self.is_over():
    return "game is over"
  else:
    return "game is active"


method determine_winner(self: Game) {.base.} =
  raise newException(FieldError, "determine_winner() must be overridden")


method scoring*(self: Game): int {.base.} =
  raise newException(FieldError, "scoring() must be overridden (if used)")


method setup*(self: Game, players: seq[Player]) {.base.} =
  raise newException(FieldError, "setup() must be overridden")


method default_setup*(self: Game, players: seq[Player]) {.base.} =
  self.players = players
  self.player_count = len(self.players)
  self.current_player_number = 1
  self.winner_player_number = 0


method play*(self: Game) : seq[string] {.base discardable.} = 
  var history: seq[string] = @[]
  var move: string = ""
  while not self.is_over():
    # when declaredInScope(self.status):
    #   self.current_player.display(self.status())
    move = self.current_player.get_move(self)
    if move.isNil:
      return history
    history.add(move)
    self.current_player.display("")
    self.current_player.display(TAB & self.make_move(move))
    self.determine_winner()
    if self.is_over():
      self.current_player.display("")
      if self.winner_player_number == STALEMATE:
        self.current_player.display("STALEMATE.")
      else:
        self.current_player.display("WINNER IS $#".format([self.winning_player.name]))
      return history
    self.current_player_number = self.next_player_number()
