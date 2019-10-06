turn_based_game Reference
==============================================================================

The following are the references for turn_based_game.



Types
=====



.. _Game.type:
Game
---------------------------------------------------------

    .. code:: nim

        Game* = ref object of RootObj
          player_count*: int
          players*: seq[Player]
          current_player_number*: int  # 1, 2, 3,... but 0 is never used
          winner_player_number*: int   # 0=no winner; -1=stalemate; n=winner


    source line: `142 <../src/turn_based_game.nim#L142>`__

    The game object to inherit from and then apply rules.
    
    For example:
    
    
    .. code:: nim
    
        type
          GameOfThai21 = ref object of Game
            pile*: int
    


.. _Player.type:
Player
---------------------------------------------------------

    .. code:: nim

        Player* = ref object of RootObj
          name*: string


    source line: `159 <../src/turn_based_game.nim#L159>`__

    The default player object. If used directly, the Player object
    is simply the end user playing the game from the OS's text console.
    
    When integrating with another framework, such as a GUI or an AI,
    have the framework's player inherit from Player.






Procs, Methods, Iterators
=========================


.. _current_player.e:
current_player
---------------------------------------------------------

    .. code:: nim

        method current_player*(self: Game) : Player {.base.} =

    source line: `247 <../src/turn_based_game.nim#L247>`__

    Return the Player whose turn it is to play


.. _default_setup.e:
default_setup
---------------------------------------------------------

    .. code:: nim

        method default_setup*(self: Game, players: seq[Player]) {.base.} =

    source line: `348 <../src/turn_based_game.nim#L348>`__

    This is the default setup for Game. You are welcome to call it when writing
    the ``setup`` method.
    
    The code is:
    
    .. code:: nim
    
        self.players = players
        self.player_count = len(self.players)
        self.current_player_number = 1
        self.winner_player_number = 0


.. _determine_winner.e:
determine_winner
---------------------------------------------------------

    .. code:: nim

        method determine_winner*(self: Game) {.base.} =

    source line: `303 <../src/turn_based_game.nim#L303>`__

    Given the current state of the game, determine who the winner is, if there
    is a winner.
    
    If running a game manually (avoiding the .play method), it is expected that
    this method is run BEFORE the turn finishes. If a winning condition is detected,
    the current player is generally assumed to be the winner that caused that
    condition.
    
    See: https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#determine_winner


.. _finish_turn.e:
finish_turn
---------------------------------------------------------

    .. code:: nim

        method finish_turn*(self: Game) {.base.} =

    source line: `269 <../src/turn_based_game.nim#L269>`__

    Cleanup anything in the current turn and start the next turn.
    
    By default, this simply changes the player number. Override this method
    if the game needs more to happen.


.. _get_move.e:
get_move
---------------------------------------------------------

    .. code:: nim

        method get_move*(self: Player, game: Game): string {.base.} =

    source line: `191 <../src/turn_based_game.nim#L191>`__



.. _get_state.e:
get_state
---------------------------------------------------------

    .. code:: nim

        method get_state*(self: Game): string {.base.} =

    source line: `324 <../src/turn_based_game.nim#L324>`__

    Returns a string that is encoded to represent the current game, including who
    the current player is.
    
    This method is not actually used by this library; but is used by some
    external AI libraries.


.. _is_over.e:
is_over
---------------------------------------------------------

    .. code:: nim

        method is_over*(self: Game): bool {.base.} =

    source line: `288 <../src/turn_based_game.nim#L288>`__

    Return whether or not the game is over.


.. _make_move.e:
make_move
---------------------------------------------------------

    .. code:: nim

        method make_move*(self: Game, move: string): string {.base.} =

    source line: `277 <../src/turn_based_game.nim#L277>`__

    Given a move (from ``set_possible_moves``), apply that move
    to the game.
    
    This is where most of the rules of the game are coded. This method
    MUST be overridden.
    
    See: https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#make_move


.. _next_player_number.e:
next_player_number
---------------------------------------------------------

    .. code:: nim

        method next_player_number*(self: Game): int {.base.} =

    source line: `264 <../src/turn_based_game.nim#L264>`__

    Return the number to the next player.


.. _play.e:
play
---------------------------------------------------------

    .. code:: nim

        method play*(self: Game) : seq[string] {.base discardable.} =

    source line: `367 <../src/turn_based_game.nim#L367>`__

    Start and run the game. Unless this method is overriden, this plays
    the game from the text console.


.. _restore_state.e:
restore_state
---------------------------------------------------------

    .. code:: nim

        method restore_state*(self: Game, state: string): void  {.base.} =

    source line: `333 <../src/turn_based_game.nim#L333>`__

    Decodes the string to reset the game to the state encoded in the string.
    
    This method is not actually used by this library; but is used by some
    external AI libraries.


.. _scoring.e:
scoring
---------------------------------------------------------

    .. code:: nim

        method scoring*(self: Game): float {.base.} =

    source line: `316 <../src/turn_based_game.nim#L316>`__

    Return a score reflecting the advantage to the current player.
    
    This method is not actually used by this library; but is used by some
    external AI libraries.


.. _set_possible_moves.e:
set_possible_moves
---------------------------------------------------------

    .. code:: nim

        method set_possible_moves*(self: Game, moves: var OrderedTable[string, string]) {.base.} =

    source line: `241 <../src/turn_based_game.nim#L241>`__

    Set the current possible moves of the game.
    See https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#set_possible_moves


.. _set_possible_moves.e:
set_possible_moves
---------------------------------------------------------

    .. code:: nim

        method set_possible_moves*(self: Game, moves: var seq[string]) {.base.} =

    source line: `235 <../src/turn_based_game.nim#L235>`__

    Set the current possible moves of the game.
    See https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#set_possible_moves


.. _setup.e:
setup
---------------------------------------------------------

    .. code:: nim

        method setup*(self: Game, players: seq[Player]) {.base.} =

    source line: `341 <../src/turn_based_game.nim#L341>`__

    Setup the board; resetting all state for a new game.
    
    See https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#setup


.. _status.e:
status
---------------------------------------------------------

    .. code:: nim

        method status*(self: Game): string {.base.} =

    source line: `293 <../src/turn_based_game.nim#L293>`__

    Return a status of the game overrall. By default, it simply returns either
    "game is over" or "game is active". Override this method for something
    more sophisticated.


.. _winning_player.e:
winning_player
---------------------------------------------------------

    .. code:: nim

        method winning_player*(self: Game) : Player {.base.} =

    source line: `252 <../src/turn_based_game.nim#L252>`__

    Return the Player who is the winner.
    If there is no winner, a "false" Player is returned with the name
    "NO WINNER YET" or "STALEMATE OR TIE"







Table Of Contents
=================

1. `Introduction to turn_based_game <index.rst>`__
2. Appendices

    A. `turn_based_game Reference <turn_based_game-ref.rst>`__
