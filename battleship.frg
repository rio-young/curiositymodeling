#lang forge/bsl

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
    ships: pfunc Int -> Int -> Ship
}

// 5 ships each of sizes 5, 4, 3, 3, 2
sig Ship{
  size: one Int,
  isSunk: one Boolean
  //Everything but ship should be null, initially all places in ship should be False
  // shipHit: pfunc Int -> Int -> Boolean
}


pred hori_ship_2[ship:Ship, board: Board]{
  some row, col: Int | {
    board.ships[row][col] = ship and board.ships[add[row, 1]][col] = ship
    all row2, col2: Int | {
      (not ((row2 = row and col2 = col) or (row2 = add[row, 1] and col2 = col)))  implies no board.ships[row2][col2]
    }
  }
}

pred vert_ship_2[ship:Ship, board: Board]{
  some row, col: Int | {
    board.ships[row][col] = ship and board.ships[row][add[col, 1]] = ship
    all row2, col2: Int | {
      ((row2 != row or col2 != col) and (row2 != row or col2 != add[col, 1]))  implies no board.ships[row2][col2]
    }
  }
}

//Assumes that the ship being passed in is of size 2
pred shipSize2[ship:Ship, board: Board]{
  // assert ship.size = 2

  hori_ship_2[ship, board] 
  // vert_ship_2[ship, board]

  // hori_ship_2[ship, board] <=> not vert_ship_2[ship, board]
  // vert_ship_2[ship, board] <=> not hori_ship_2[ship, board] 
  
}


//Assumes that the ship being passed in is of size 3
pred shipSize3[ship:Ship, board: Board]{
  // assert ship.size = 2
  #{row, col: Int | board.ships[row][col] = ship} = 3
  some row, col: Int | {
    //Horizontal
    (board.ships[row][col] = ship and 
    board.ships[add[row, 1]][col] = ship and 
    board.ships[add[row, 2]][col] = ship) or
    //Vertical
    (board.ships[row][col] = ship and 
    board.ships[row][add[col, 1]] = ship and 
    board.ships[row][add[col, 2]] = ship)
  }
}

//Assumes that the ship being passed in is of size 4
pred shipSize4[ship:Ship, board: Board]{
  // assert ship.size = 2
  #{row, col: Int | board.ships[row][col] = ship} = 4
  some row, col: Int | {
    //Horizontal
    (board.ships[row][col] = ship and 
    board.ships[add[row, 1]][col] = ship and 
    board.ships[add[row, 2]][col] = ship and 
    board.ships[add[row, 3]][col] = ship) or
    //Vertical
    (board.ships[row][col] = ship and 
    board.ships[row][add[col, 1]] = ship and 
    board.ships[row][add[col, 2]] = ship and 
    board.ships[row][add[col, 3]] = ship)
  }
}

//Assumes that the ship being passed in is of size 4
pred shipSize5[ship:Ship, board: Board]{

  #{row, col: Int | board.ships[row][col] = ship} = 5
  some row, col: Int | {
    //Horizontal
    (board.ships[row][col] = ship and 
    board.ships[add[row, 1]][col] = ship and 
    board.ships[add[row, 2]][col] = ship and 
    board.ships[add[row, 3]][col] = ship and 
    board.ships[add[row, 4]][col] = ship) or
    //Vertical
    (board.ships[row][col] = ship and 
    board.ships[row][add[col, 1]] = ship and 
    board.ships[row][add[col, 2]] = ship and 
    board.ships[row][add[col, 3]] = ship and 
    board.ships[row][add[col, 4]] = ship)
  }
}

// All ships must be placed on the board, and must be placed horizontally or vertically - John
pred ship_wellformed[board: Board] {
  // Align horizonally or vertically if > 1
  // Size = to number of positions
  all ship: Ship | {
    ship.size > 1
    ship.size < 6

    //REMOVE LATER
    ship.size = 2

    ship.size = 2 implies shipSize2[ship, board]
    ship.size = 3 implies shipSize3[ship, board]
    ship.size = 4 implies shipSize4[ship, board]
    ship.size = 5 implies shipSize5[ship, board]

  }
  // Check if ship is sunk - Rio
    // If for each existance on the board there is a shot on the baord
}


//checks if there is exactly one ship where the size is equal to size
pred shipOfAllSizes[board: Board]{
  #{ship: Ship | ship.size = 2} = 1
  #{ship: Ship | ship.size = 3} = 2
  #{ship: Ship | ship.size = 4} = 1
  #{ship: Ship | ship.size = 5} = 1
}

// Init state of the game - Rio
pred init[board: BoardState] {

  // Board needs to all be false
  all row, col: Int | {
    board.player1.shots[row][col] = False
    board.player2.shots[row][col] = False
  }
  // 5 ships for each player
  // All 5 shapes for each player
  // shipOfAllSizes[board.player1]
  // shipOfAllSizes[board.player2]

  ship_wellformed[board.player1]
  ship_wellformed[board.player2]

  all ship: Ship | {
    ship.isSunk = False
  }

}

fun MAX: one Int { 7 }

// //checks if there is exactly one ship where the size is equal to size
// pred shipOfSize[size: Int, player: Player]{
//   one ship: Ship | {
//     #{row, col: Int | player.playerBoard.ships[row][col] = ship} = size
//   }
// }

// Two 10 x 10 boards, one for each player - John
pred board_wellformed {
  // Player shots have to be 0-9
  // Player ships have to be 0-9
  all row, col: Int, board: Board | {
    board.shots[row][col] = True implies row >= 0 and row <= MAX and col >= 0 and col <= MAX
    // (row < 0 or row > MAX or col < 0 or col > MAX) implies no board.shots[row][col]
    all ship: Ship | {
      board.ships[row][col] = ship implies row >= 0 and row <= MAX and col >= 0 and col <= MAX
      
    }
  }

  // Check no ships are overlapping
  all row, col: Int, board: Board | {
    some ship1, ship2: Ship | {
      board.ships[row][col] = ship1 and board.ships[row][col] = ship2 implies ship1 = ship2
    }
  }



}


// Go turn by turn
// Each turn is either a hit or miss
  // Hit: the position corresponds to a ship on the other players board
  // Miss: does not hit
pred move {
  // Count shots and determine player one or player two
  // If both players haven same then player one ortherwise player two
  // Check if the spot has not been shot
  // If has not then make shot make sure shot is within 0-9
}

// pred game_trace {
//     initial[Game.first]
//     all b: Board | { some Game.next[b] implies {
//         some row, col: Int, p: Player | 
//             move[b, row, col, p, Game.next[b]]
//         -- TODO: ensure X moves first
//     }}
// }
pred trace {
  // Init
  init[Game.first]
  // Board wellformed
  board_wellformed
  // Ship wellformed
  // Move
  // Check for win and keep same if won
}

run {trace} for exactly 1 BoardState, exactly 1 Ship

// When all positions on boat are hit, the ship is sunk
// pred shipSunk{}

// Winning
pred winning {
  // Check if a player has all their ships sunk
  // Wining previousely implies the game state
}

// When all boats for a player are sunk, they lose and the game ends
pred allBoatsSunk[board: Board] {
  // Check all the ships are sunk for the player
}


