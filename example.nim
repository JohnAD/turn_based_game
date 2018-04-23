# game of bones example
#
import turn_based_game

# Start a match
var game = Game()
game.setup( @[GenericPlayer(name: "PlayerOne"), GenericPlayer(name: "PlayerTwo")] )
var history = game.play()
echo ""
echo "history:"
echo "  ", history
