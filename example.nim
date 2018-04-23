# game of bones example
#
import turn_based_game

# Start a match
let game = newGame( @[GenericPlayer(name: "PlayerOne"), GenericPlayer(name: "PlayerTwo")] )
var history = game.play()
echo "history:"
echo history
