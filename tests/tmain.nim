import unittest

import tables

import turn_based_game
import examplegame

const three_poss = {"1": "Take One", "2": "Take Two", "3": "Take Three"}.toOrderedTable

suite "run the simple example game of Thai 21":
  test "play a full game with three players":

    var game = GameOfThai21()

    game.setup(@[Player(name: "A"), Player(name: "B"), Player(name: "C")])
    var possibleMoves: OrderedTable[string, string]


    # player A, round 1
    assert game.status == "[21] flags available."
    game.set_possible_moves(possibleMoves)
    assert possibleMoves == three_poss
    discard game.make_move("2")
    game.determine_winner
    game.finish_turn
    assert game.winner_player_number == 0
 
    # player B, round 1
    assert game.status == "[19] flags available."
    game.set_possible_moves(possibleMoves)
    assert possibleMoves == three_poss
    discard game.make_move("2")
    game.determine_winner
    game.finish_turn
    assert game.winner_player_number == 0
 
    # player C, round 1
    assert game.status == "[17] flags available."
    game.set_possible_moves(possibleMoves)
    assert possibleMoves == three_poss
    discard game.make_move("2")
    game.determine_winner
    game.finish_turn
    assert game.winner_player_number == 0
 
    # player A, round 2
    assert game.status == "[15] flags available."
    game.set_possible_moves(possibleMoves)
    assert possibleMoves == three_poss
    discard game.make_move("3")
    game.determine_winner
    game.finish_turn
    assert game.winner_player_number == 0
 
    # player B, round 2
    assert game.status == "[12] flags available."
    game.set_possible_moves(possibleMoves)
    assert possibleMoves == three_poss
    discard game.make_move("3")
    game.determine_winner
    game.finish_turn
    assert game.winner_player_number == 0
 
    # player C, round 2
    assert game.status == "[9] flags available."
    game.set_possible_moves(possibleMoves)
    assert possibleMoves == three_poss
    discard game.make_move("3")
    game.determine_winner
    game.finish_turn
    assert game.winner_player_number == 0
 
     # player A, round 3
    assert game.status == "[6] flags available."
    game.set_possible_moves(possibleMoves)
    assert possibleMoves == three_poss
    discard game.make_move("3")
    game.determine_winner
    game.finish_turn
    assert game.winner_player_number == 0
 
    # player B, round 3
    assert game.status == "[3] flags available."
    game.set_possible_moves(possibleMoves)
    assert possibleMoves == three_poss
    discard game.make_move("2")
    game.determine_winner
    game.finish_turn
    assert game.winner_player_number == 0
 
    # player C, round 3
    assert game.status == "[1] flags available."
    game.set_possible_moves(possibleMoves)
    assert possibleMoves == {"1": "Take One"}.toOrderedTable
    discard game.make_move("1")
    game.determine_winner
    game.finish_turn
    assert game.winner_player_number == 3  # player C wins!
 
    assert game.is_over()
