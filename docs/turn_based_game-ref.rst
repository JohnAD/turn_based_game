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


    source line: `156 <../src/turn_based_game.nim#L156>`__

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

    source line: `244 <../src/turn_based_game.nim#L244>`__

    Return the Player whose turn it is to play


.. _default_setup.e:
default_setup
---------------------------------------------------------

    .. code:: nim

        method default_setup*(self: Game, players: seq[Player]) {.base.} =

    source line: `340 <../src/turn_based_game.nim#L340>`__

    This is the default setup for Game. You are welcome to call it when writing
    the ``setup`` method.
    
    The code is:
    
    .. code:: nim
    
        self.players = players
        self.player_count = len(self.players)
        self.current_player_number = 1
        self.winner_player_number = 0


.. _finish_turn.e:
finish_turn
---------------------------------------------------------

    .. code:: nim

        method finish_turn*(self: Game) {.base.} =

    source line: `266 <../src/turn_based_game.nim#L266>`__

    Cleanup anything in the current turn and start the next turn.
    
    By default, this simply changes the player number. Override this method
    if the game needs more to happen.


.. _get_move.e:
get_move
---------------------------------------------------------

    .. code:: nim

        method get_move*(self: Player, game: Game): string {.base.} =

    source line: `188 <../src/turn_based_game.nim#L188>`__



.. _get_state.e:
get_state
---------------------------------------------------------

    .. code:: nim

        method get_state*(self: Game): string {.base.} =

    source line: `316 <../src/turn_based_game.nim#L316>`__

    Returns a string that is encoded to represent the current game, including who
    the current player is.
    
    This method is not actually used by this library; but is used by some
    external AI libraries.


.. _is_over.e:
is_over
---------------------------------------------------------

    .. code:: nim

        method is_over*(self: Game): bool {.base.} =

    source line: `285 <../src/turn_based_game.nim#L285>`__

    Return whether or not the game is over.


.. _make_move.e:
make_move
---------------------------------------------------------

    .. code:: nim

        method make_move*(self: Game, move: string): string {.base.} =

    source line: `274 <../src/turn_based_game.nim#L274>`__

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

    source line: `261 <../src/turn_based_game.nim#L261>`__

    Return the index to the next player.


.. _play.e:
play
---------------------------------------------------------

    .. code:: nim

        method play*(self: Game) : seq[string] {.base discardable.} =

    source line: `359 <../src/turn_based_game.nim#L359>`__

    Start and run the game. Unless this method is overriden, this plays
    the game from the text console.


.. _restore_state.e:
restore_state
---------------------------------------------------------

    .. code:: nim

        method restore_state*(self: Game, state: string): void  {.base.} =

    source line: `325 <../src/turn_based_game.nim#L325>`__

    Decodes the string to reset the game to the state encoded in the string.
    
    This method is not actually used by this library; but is used by some
    external AI libraries.


.. _scoring.e:
scoring
---------------------------------------------------------

    .. code:: nim

        method scoring*(self: Game): float {.base.} =

    source line: `308 <../src/turn_based_game.nim#L308>`__

    Return a score reflecting the advantage to the current player.
    
    This method is not actually used by this library; but is used by some
    external AI libraries.


.. _set_possible_moves.e:
set_possible_moves
---------------------------------------------------------

    .. code:: nim

        method set_possible_moves*(self: Game, moves: var OrderedTable[string, string]) {.base.}

    source line: `173 <../src/turn_based_game.nim#L173>`__



.. _set_possible_moves.e:
set_possible_moves
---------------------------------------------------------

    .. code:: nim

        method set_possible_moves*(self: Game, moves: var OrderedTable[string, string]) {.base.} =

    source line: `238 <../src/turn_based_game.nim#L238>`__

    Set the current possible moves of the game.
    See https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#set_possible_moves


.. _set_possible_moves.e:
set_possible_moves
---------------------------------------------------------

    .. code:: nim

        method set_possible_moves*(self: Game, moves: var seq[string]) {.base.}

    source line: `174 <../src/turn_based_game.nim#L174>`__



.. _set_possible_moves.e:
set_possible_moves
---------------------------------------------------------

    .. code:: nim

        method set_possible_moves*(self: Game, moves: var seq[string]) {.base.} =

    source line: `232 <../src/turn_based_game.nim#L232>`__

    Set the current possible moves of the game.
    See https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#set_possible_moves


.. _setup.e:
setup
---------------------------------------------------------

    .. code:: nim

        method setup*(self: Game, players: seq[Player]) {.base.} =

    source line: `333 <../src/turn_based_game.nim#L333>`__

    Setup the board; resetting all state for a new game.
    
    See https://github.com/JohnAD/turn_based_game/wiki/Game-Object-Methods#setup


.. _status.e:
status
---------------------------------------------------------

    .. code:: nim

        method status*(self: Game): string {.base.}

    source line: `175 <../src/turn_based_game.nim#L175>`__



.. _status.e:
status
---------------------------------------------------------

    .. code:: nim

        method status*(self: Game): string {.base.} =

    source line: `290 <../src/turn_based_game.nim#L290>`__

    Return a status of the game overrall. By default, it simply returns either
    "game is over" or "game is active". Override this method for something
    more sophisticated.


.. _winning_player.e:
winning_player
---------------------------------------------------------

    .. code:: nim

        method winning_player*(self: Game) : Player {.base.} =

    source line: `249 <../src/turn_based_game.nim#L249>`__

    Return the Player who is the winner.
    If there is no winner, a "false" Player is returned with the name
    "NO WINNER YET" or "STALEMATE OR TIE"







Table Of Contents
=================

1. `Introduction to turn_based_game <index.rst>`__
2. Appendices

    A. `turn_based_game Reference <turn_based_game-ref.rst>`__
