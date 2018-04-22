# turn_based_game module
#

type
  Game = ref object of RootObj
    player_count*: int
    players*: array(int)
    current_player*: int

    pile*: int  # later make this part added


method possible_moves(self: Game): array(string) =
  ['1','2','3']


method make_move(self: Game, move: string): void =
  self.pile -= int(move) # remove bones.


method win(self: Game): bool =
  self.pile <= 0 # opponent took the last bone ?


method is_over(self: Game): bool =
  self.win() # Game stops when someone wins.


method show(self: Game): string =
  "%d bones left in the pile"%self.pile


method scoring(self: Game): int =
  100 if game.win() else 0

