# game of bones example
#
import turn_based_game
import strutils

#
#  add our rules for "game of bones"
#

type
  Square = enum
    empty, X, O
  TicTacToe = ref object of Game
    board*: array[0..8, Square]

#[
The board positions are numbered as follows:
            0 1 2
            3 4 5
            6 7 8
]#    

method possible_moves(self: TicTacToe): seq[string] =
  result = @[]
  for i, x in self.board:
    if x==empty:
      result.add($i)


method make_move(self: TicTacToe, move: string): string =
  var pos = move.parseInt()
  if self.current_player_number == 1:
    self.board[pos] = X
  else:
    self.board[pos] = O
  return "played [$#].".format([pos])


method status(self: TicTacToe): string =
  result = "\n"
  var index: int
  for j in countUp(0, 2):
    for i in countUp(0, 2):
      index = 3 * j + i
      result.add($index)
      if self.board[index] == empty:
        result.add("[ ] ")
      else:
        result.add("[$#] ".format(self.board[index]))
    result.add("\n")


method scoring(self: TicTacToe): int =
  if self.winner_player_number > 0:
    return 100
  return 0


method setup*(self: TicTacToe, players: seq[GenericPlayer]) =
  self.default_setup(players)
  self.board = [
    empty, empty, empty,
    empty, empty, empty,
    empty, empty, empty    
  ]


#
# Start a match
#
var game = TicTacToe()
game.setup( @[GenericPlayer(name: "X"), GenericPlayer(name: "O")] )
var history = game.play()
echo ""
echo "history:"
echo "  ", history
