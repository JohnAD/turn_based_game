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
    current_player_number*: int  # 1, 2, 3,... but 0 is never used
    winner_player_number*: int   # 0=no winner; -1=stalemate; n=winner

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
  raise newException(FieldError, "set_possible_moves(OrderedTable) must be overridden")


method current_player*(self: Game) : Player {.base.} =
  self.players[self.current_player_number - 1]


method winning_player*(self: Game) : Player {.base.} =
  if self.winner_player_number > NO_WINNER_YET:
    return self.players[self.winner_player_number - 1]
  elif self.winner_player_number == NO_WINNER_YET:
    return Player(name: "NO WINNER YET")
  else:
    return Player(name: "STALEMATE OR TIE")


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


method scoring*(self: Game): float {.base.} =
  raise newException(FieldError, "scoring() must be overridden (if used)")


method get_state*(self: Game): string {.base.} =
  raise newException(FieldError, "get_state() must be overridden (if used)")


method restore_state*(self: Game, state: string): void  {.base.} =
  raise newException(FieldError, "restore_state() must be overridden (if used)")


method setup*(self: Game, players: seq[Player]) {.base.} =
  raise newException(FieldError, "setup() must be overridden")


method default_setup*(self: Game, players: seq[Player]) {.base.} =
  self.players = players
  self.player_count = len(self.players)
  self.current_player_number = 1
  self.winner_player_number = 0


method play*(self: Game) : seq[string] {.base discardable.} = 
  result = @[]
  var move: string = ""
  while not self.is_over():
    self.current_player.display("-----------------")
    self.current_player.display("$1's Turn".format(self.current_player.name))
    move = self.current_player.get_move(self)
    if move.isNil:
      break
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
