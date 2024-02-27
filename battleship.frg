#lang forge/bsl
option run_sterling "vis.js"

abstract sig Boolean {}
one sig True, False extends Boolean {}

one sig Game {
  first: one BoardState,
  next: pfunc BoardState -> BoardState
}

sig BoardState {
  player1: one Board,
  player2: one Board
}

sig Board {
    //should all be false initially, true means the other player shot at that postion
    shots: pfunc Int -> Int -> Boolean,
    ships: pfunc Int -> Int -> Boolean
}

fun countShots[board: Board] : Int {
  #{row, col: Int | board.shots[row][col] = True}
}

fun countShips[board: Board] : Int {
  #{row, col: Int | board.ships[row][col] = True}
}

pred shipSizeOne[board: Board, row, col: Int] {
  board.ships[row][col] = True
}

pred shipSizeTwo[board: Board, row, col: Int] {
  (board.ships[row][col] = True and
  board.ships[row][add[col, 1]] = True)
  or
  (board.ships[row][col] = True and
  board.ships[add[row, 1]][col] = True)
}

pred shipSizeThree[board: Board, row, col: Int] {
  (board.ships[row][col] = True and
  board.ships[row][add[col, 1]] = True and
  board.ships[row][add[col, 2]] = True)
  or
  (board.ships[row][col] = True and
  board.ships[add[row, 1]][col] = True and
  board.ships[add[row, 2]][col] = True)
}

pred shipSizeFour[board: Board, row, col: Int] {
  (board.ships[row][col] = True and
  board.ships[row][add[col, 1]] = True and
  board.ships[row][add[col, 2]] = True and
  board.ships[row][add[col, 3]] = True)
  or
  (board.ships[row][col] = True and
  board.ships[add[row, 1]][col] = True and
  board.ships[add[row, 2]][col] = True and
  board.ships[add[row, 3]][col] = True)
}

pred shipSizeFive[board: Board, row, col: Int] {
  (board.ships[row][col] = True and
  board.ships[row][add[col, 1]] = True and
  board.ships[row][add[col, 2]] = True and
  board.ships[row][add[col, 3]] = True and
  board.ships[row][add[col, 4]] = True)
  or
  (board.ships[row][col] = True and
  board.ships[add[row, 1]][col] = True and
  board.ships[add[row, 2]][col] = True and
  board.ships[add[row, 3]][col] = True and
  board.ships[add[row, 4]][col] = True)
}

// Ships are wellformed
pred ship_wellformed[board: Board] {

  // One ship of size 5
  one row1, col1, row2, col2, row3, col3, row4, col4, row5, col5: Int | {
    shipSizeFive[board, row1, col1]
    and
    shipSizeFour[board, row2, col2]
    and
    shipSizeThree[board, row3, col3]
    and
    shipSizeTwo[board, row4, col4]
    and
    shipSizeOne[board, row5, col5]
  }

  countShips[board] = 15
}

// Init state of the game - Rio
pred init[board: BoardState] {

  // Board needs to all be false
  all row, col: Int | {
    board.player1.shots[row][col] = False
    board.player2.shots[row][col] = False
  }

  ship_wellformed[board.player1]
  ship_wellformed[board.player2]
}

fun MAX: one Int { 7 }

// Two 10 x 10 boards, one for each player - John
pred board_wellformed {
  // Player shots have to be 0-9
  // Player ships have to be 0-9
  all row, col: Int, board: Board | {
    board.shots[row][col] = True implies row >= 0 and row <= MAX and col >= 0 and col <= MAX
    board.shots[row][col] != True implies board.shots[row][col] = False
    board.ships[row][col] = True implies row >= 0 and row <= MAX and col >= 0 and col <= MAX
  }

  // Player ships are consistent across board states
  all b1, b2: BoardState | {
    all row, col: Int | {
      b1.player1.ships[row][col] = b2.player1.ships[row][col]
      b1.player2.ships[row][col] = b2.player2.ships[row][col]
    }
  }

}

pred player1Turn[b: BoardState] {
  countShots[b.player1] = countShots[b.player2]
}

pred player2Turn[b: BoardState] {
  countShots[b.player1] = add[countShots[b.player2], 1]
}

pred balancedTurns[b: BoardState] {
  player1Turn[b] or player2Turn[b]
}

pred move[pre, post: BoardState, row, col: Int] {
  // Check if the position has already been shot at
  balancedTurns[pre]
  
  player1Turn[pre] => {
    pre.player1.shots[row][col] = False
    post.player1.shots[row][col] = True

    all row1, col1: Int | {
      (row1 != row or col1 != col) =>
      pre.player1.shots[row1][col1] = post.player1.shots[row1][col1]
    }

    all row1, col1: Int | {
      pre.player2.shots[row1][col1] = post.player2.shots[row1][col1]
    }
  }

  player2Turn[pre] => {
    pre.player2.shots[row][col] = False
    post.player2.shots[row][col] = True

    all row1, col1: Int | {
      (row1 != row or col1 != col) =>
      pre.player2.shots[row1][col1] = post.player2.shots[row1][col1]
    }

    all row1, col1: Int | {
      pre.player1.shots[row1][col1] = post.player1.shots[row1][col1]
    }
  }
}

pred trace {
  // Init
  init[Game.first]
  // Board wellformed
  board_wellformed
  // Ship wellformed

  // Move
  all b: BoardState | { 
    some Game.next[b] => {
      some row, col: Int | {
        move[b, Game.next[b], row, col]
      } 
    }
  }
  // Check for win and keep same if won
}

run {trace} for 1 BoardState for {next is linear}

// // Winning
// pred winning[b: BoardState] {
//   // Check if a player has all their ships sunk
//   // Wining previousely implies the game state
//   allBoatsSunk[b.player1] or
//   allBoatsSunk[b.player2]

// }

// // When all positions on boat are hit, the ship is sunk
// //Assumes that because we check ship_sunk_wellformed, a ship's isSunk will only be True if it is actually sunk
// pred ship_sunk[board: Board, row, col: Int]{
//   board.ships[row][col] = True and board.shots[row][col] = True
// }

// // When all boats for a player are sunk, they lose and the game ends
// pred allBoatsSunk[board: Board] {
//   // Check all the ships are sunk for the player
//   all row, col: Int | {
//     board.shots[row][col] = True => ship_sunk[board, row, col]
//   }
// }


