# turn_based_game
# Copyright John Dupuy
# Game rules framework for turn-based games

import strutils

## #######################################
## 
##   Type Definitions
## 
## ######################################

type

  Game* = ref object of RootObj
    player_count*: int
    players*: seq[GenericPlayer]
    current_player_number*: int
    winner_player_number*: int

  GenericPLayer* = ref object of RootObj
    name*: string


# the following prototype is needed to allow mutual recursion of methods
#   It is properly defined later.
method possible_moves*(self: Game): seq[string] {.base.}


## ## ## #######################################
## 
##   GenericPlayer
## 
## ######################################

method display(self: GenericPlayer, msg: string) {.base.} =
    echo $msg

method get_move(self: GenericPlayer, game: Game): string {.base.} = 
  while true:
    echo ""
    echo "It is $#'s turn.".format([self.name])
    echo "Possible moves:"
    var move_list = game.possible_moves()
    echo move_list
    echo "Enter move (or 'quit'): "
    var response = readLine(stdin)
    if response in move_list:
      return response
    if response == "quit":
      return "___quit___"
    echo "BAD ENTRY. Try again."

## #######################################
## 
##   Game
## 
## ######################################


method possible_moves*(self: Game): seq[string] {.base.} =
  raise newException(FieldError, "possible_moves() must be overridden")


method current*(self: Game) : GenericPlayer {.base.} =
  self.players[self.current_player_number - 1]


method winner*(self: Game) : GenericPlayer {.base.} =
  self.players[self.winner_player_number - 1]


method next_player_number*(self: Game): int {.base.} =
  (self.current_player_number %% self.player_count) + 1


method finish_turn*(self: Game) {.base.} =
  self.current_player_number = self.next_player_number()


method make_move*(self: Game, move: string): string {.base.} =
  raise newException(FieldError, "make_move() must be overridden")


method is_over*(self: Game): bool {.base.} =
  self.winner_player_number > 0


method status*(self: Game): string {.base.} =
  raise newException(FieldError, "status() must be overridden")


method scoring*(self: Game): int {.base.} =
  raise newException(FieldError, "scoring() must be overridden")


method setup*(self: Game, players: seq[GenericPlayer]) {.base.} =
  raise newException(FieldError, "setup() must be overridden")


method default_setup*(self: Game, players: seq[GenericPlayer]) {.base.} =
  self.player_count = 2
  self.players = players
  self.current_player_number = 1
  self.winner_player_number = 0


method play*(self: Game) : seq[string] {.base.} = 
  var history: seq[string] = @[]
  var move: string = ""
  while not self.is_over():
    self.current.display(self.status())
    move = self.current.get_move(self)
    if move == "___quit___":
      return history
    history.add(move)
    self.current.display(self.make_move(move))
    if self.is_over():
      self.current.display("winner is $#".format([self.winner.name]))
      return history
    self.current_player_number = self.next_player_number()
