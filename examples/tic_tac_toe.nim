# tic tac toe example
# aka "naughts and crosses"
#
import turn_based_game
import strutils

#
#  add our rules for "game of bones"
#

type
  TicTacToe = ref object of Game
    board*: array[0..8, int]

#[
The board positions are numbered as follows:
            0 1 2
            3 4 5
            6 7 8
]#    

const
  empty = 0
  X = 1
  O = 2
  DESC = [" ", "X", "O"]

method setup*(self: TicTacToe, players: seq[Player]) =
  self.default_setup(players)
  self.board = [
    empty, empty, empty,
    empty, empty, empty,
    empty, empty, empty    
  ]

method set_possible_moves*(self: TicTacToe, moves: var seq[string]) =
  moves = @[]
  for i, x in self.board:
    if x==empty:
      moves.add($i)


method make_move(self: TicTacToe, move: string): string =
  var pos = move.parseInt()
  if self.current_player_number == 1:
    self.board[pos] = X
  else:
    self.board[pos] = O
  return "$# placed in [$#].".format(DESC[self.board[pos]], pos)


const WINNING_MOVES = [
  [0, 1, 2], # top row
  [3, 4, 5], # middle row
  [6, 7, 8], # bottom row
  [0, 3, 6], # left column
  [1, 4, 7], # center column
  [2, 5, 8], # right column
  [0, 4, 8], # diagonal 45 deg
  [2, 4, 6], # diagonal -45 deg
]

method determine_winner(self: TicTacToe) =
  if self.winner_player_number != NO_WINNER_YET:
    return
  var winFlags = [0, 0, 0]
  for path in WINNING_MOVES:
    winFlags = [0, 0, 0]
    for pos in path:
      inc(winFlags[self.board[pos]])
    if winFlags[X] == 3:
      self.winner_player_number = 1
      return
    if winFlags[O] == 3:
      self.winner_player_number = 2
      return
  var staleMate = true
  for square in self.board:
    if square==0:
      staleMate = false
  if staleMate:
    self.winner_player_number = STALEMATE
  return


method status(self: TicTacToe): string =
  result = ""
  var index: int
  for j in countUp(0, 2):
    for i in countUp(0, 2):
      index = 3 * j + i
      result.add($index)
      result.add("[$#] ".format(DESC[self.board[index]]))
    if j<2:
      result.add("\n")


#
# Start a match
#
var game = TicTacToe()
game.setup( @[Player(name: "X"), Player(name: "O")] )
var history = game.play()
echo ""
echo "history:"
echo "  ", history
