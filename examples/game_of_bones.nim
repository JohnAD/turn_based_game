# game of bones example
#
import turn_based_game
import strutils

#
#  add our rules for "game of bones"
#

type
  GameOfBones = ref object of Game
    pile*: int


method possible_moves(self: GameOfBones): seq[string] =
  var limit = 2
  if self.pile < 3:
    limit = self.pile - 1
  @["1", "2", "3"][0..limit]


method make_move(self: GameOfBones, move: string): string =
  var count = move.parseInt()
  self.pile -= count  # remove bones.
  if self.pile <= 0:
    self.winner_player_number = self.next_player_number()
  return "$# bones removed.".format([count])


method status(self: GameOfBones): string =
  "$# bones left in the pile" .format([self.pile])


method scoring(self: GameOfBones): int =
  if self.winner_player_number > 0:
    return 100
  return 0


method setup*(self: GameOfBones, players: seq[GenericPlayer]) =
  self.default_setup(players)
  self.pile = 20


#
# Start a match
#
var game = GameOfbones()
game.setup( @[GenericPlayer(name: "PlayerOne"), GenericPlayer(name: "PlayerTwo")] )
var history = game.play()
echo ""
echo "history:"
echo "  ", history
