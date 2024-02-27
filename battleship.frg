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

// All ships must be placed on the board, and must be placed horizontally or vertically - Rio
pred ship_wellformed[board: Board] {
  countShips[board] = 5
}

// Init state of the game - Rio
pred init[board: BoardState] {

  // Board needs to all be false
  all row, col: Int | {
    (row >= 0 and row <= MAX and col >= 0 and col <= MAX) implies board.player1.shots[row][col] = False
    (row >= 0 and row <= MAX and col >= 0 and col <= MAX) implies board.player2.shots[row][col] = False
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
    not no board.shots[row][col] implies row >= 0 and row <= MAX and col >= 0 and col <= MAX
    not no board.ships[row][col] implies row >= 0 and row <= MAX and col >= 0 and col <= MAX
  }

  // all b: Board | { 
  //       all row, col: Int | {
  //           (row < 0 or row > MAX or 
  //           col < 0 or col > MAX) implies
  //               no b.shots[row][col]
  //               // no b.ships[row][col]
  //   } }

  // all boardState: BoardState | {
  //   boardState.player1 != boardState.player2
  // }

  // all disj b1, b2: BoardState | {
  //   b1.player1 != b2.player1
  //   b1.player1 != b2.player2
  //   b1.player2 != b2.player1
  //   b1.player2 != b2.player2
  // }

}

// run {board_wellformed} for 1 BoardState


pred player1Turn[b: BoardState] {
  countShots[b.player1] = countShots[b.player2]
}
pred player2Turn[b: BoardState] {
  countShots[b.player1] = add[countShots[b.player2], 1]
}

// Go turn by turn
// Each turn is either a hit or miss
  // Hit: the position corresponds to a ship on the other players board
  // Miss: does not hit
pred move[pre, post: BoardState, row, col: Int] {
  // Count shots and determine player one or player two
  // If both players haven same then player one ortherwise player two
  // Check if the spot has not been shot
  // If has not then make shot make sure shot is within 0-9
  //NEED TO ENSURE SHIPS STAY WELLFORMED
  // ship_wellformed[board.player1] for pre and post
  // ship_wellformed[board.player2] for pre and post

  row >= 0 and row <= MAX
  col >= 0 and col <= MAX
  
  //If it's player 1's turn:
  player1Turn[pre] implies {
    pre.player1.shots[row][col] = False
    post.player1.shots[row][col] = True

    all row1, col1: Int | {
      //If the position is not the changed postion, it must stay the same
      (row1 != row or col1 != col) implies {
        pre.player1.shots[row1][col1] = post.player1.shots[row1][col1]
      }
      pre.player2.shots[row1][col1] = post.player2.shots[row1][col1]
    }
  }
  player2Turn[pre] => {
    pre.player2.shots[row][col] = False
    post.player2.shots[row][col] = True

    all row2, col2: Int | {
      (row2 != row or col2 != col) implies {
        pre.player2.shots[row2][col2] = post.player2.shots[row2][col2]
      }
      pre.player1.shots[row2][col2] = post.player1.shots[row2][col2]

    }
  }

  //All ships stay in the same place
  all row3, col3: Int | {
    pre.player1.ships[row3][col3] = post.player1.ships[row3][col3]
    pre.player2.ships[row3][col3] = post.player2.ships[row3][col3]
  }

  ship_wellformed[pre.player1]
  ship_wellformed[pre.player2]
  ship_wellformed[post.player1]
  ship_wellformed[post.player2]
}

pred trace {
  // Init
  init[Game.first]
  // Board wellformed
  board_wellformed
  // Ship wellformed

  // Move
  all b: BoardState | { some Game.next[b] implies {
    some row, col: Int | 
      move[b, Game.next[b], row, col]
    }}
  // Check for win and keep same if won
}

run {trace} for 5 BoardState for {next is linear}

// Winning
pred winning[b: BoardState] {
  // Check if a player has all their ships sunk
  // Wining previousely implies the game state
  allBoatsSunk[b.player1] or
  allBoatsSunk[b.player2]

}

// When all positions on boat are hit, the ship is sunk
//Assumes that because we check ship_sunk_wellformed, a ship's isSunk will only be True if it is actually sunk
pred ship_sunk[board: Board, row, col: Int]{
  board.ships[row][col] = True and board.shots[row][col] = True
}

// When all boats for a player are sunk, they lose and the game ends
pred allBoatsSunk[board: Board] {
  // Check all the ships are sunk for the player
  all row, col: Int | {
    board.shots[row][col] = True => ship_sunk[board, row, col]
  }
}


