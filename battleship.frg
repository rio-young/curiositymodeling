#lang forge/bsl

abstract sig Boolean {}
one sig True, False extends Boolean {}

sig Game {
  first: one BoardState,
  next: pfunc BoardState -> BoardState
}

sig BoardState {
  player1: one Player,
  player2: one Player
}

sig Player {
  playerBoard: one Board
} 

one sig Player1, Player2 extends Player {} 

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
// All ships must be placed on the board, and must be placed horizontally or vertically - John
pred ship_wellformed[ship: Ship] {
  // Align horizonally or vertically if > 1
  // Size = to number of positions

  // Check if ship is sunk - Rio
    // If for each existance on the board there is a shot on the baord
  all ship: Ship | {
    ship.size > 1
    ship.size < 6
  }
  // Check if ship is sunk - Rio
    // If for each existance on the board there is a shot on the baord
}


//checks if there is exactly one ship where the size is equal to size
pred shipOfAllSizes[player: Player]{
  #{ship: Ship | ship.size = 2} = 1
  #{ship: Ship | ship.size = 3} = 2
  #{ship: Ship | ship.size = 4} = 1
  #{ship: Ship | ship.size = 5} = 1

}


// // Init state of the game - Rio
// pred init {
//   // True for both players
//   all player : Player | {
//   // Board needs to all be false
//     all row, col: Int | {
//       (row >= 0 and row <= 9 and col >= 0 and col <= 9) implies player.playerBoard.shots[row][col] = False
//       // All 5 shapes for each player
//       shipOfAllSizes[player]
//     }
//   // 5 ships for each player
//   #{ship: Ship | not no ship } = 5
//   }
//   // All ships are not sunk
//   all ship: Ship | {
//     ship.isSunk = False
//     ship_wellformed[ship]
//   }
// }




// Init state of the game - Rio
pred init[board: BoardState] {
  
  // True for both players
  all player : Player | {
  
  // Board needs to all be false
    all row, col: Int | {
      not no player.playerBoard.shots[row][col] implies player.playerBoard.shots[row][col] = False

    }
  
  // 5 ships for each player
  // All 5 shapes for each player
  all player: Player | {
    shipOfAllSizes[player]
  }

  // Not shots yet
  all boards: Board | {
    all row, col: Int | {
      boards.shots[row][col] = False
    }
  }

  }
}

run {init} for exactly 1 BoardState, 5 Int, 5 Ship

//checks if there is exactly one ship where the size is equal to size
pred shipOfSize[size: Int, player: Player]{
  one ship: Ship | {
    #{row, col: Int | player.playerBoard.ships[row][col] = ship} = size
  }
}

// Two 10 x 10 boards, one for each player - John
pred board_wellformed {
  // Player shots have to be 0-9
  // Player ships have to be 0-9
  all row, col: Int, board: Board | {
    board.shots[row][col] = True implies row >= 0 and row <= 9 and col >= 0 and col <= 9

    some ship: Ship | {
      board.ships[row][col] = ship implies row >= 0 and row <= 9 and col >= 0 and col <= 9
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

pred trace {
  // Init
  // Board wellformed
  // Ship wellformed
  // Move
  // Check for win and keep same if won
}

// When all positions on boat are hit, the ship is sunk
// pred shipSunk{}

// Winning
pred winning {
  // Check if a player has all their ships sunk
  // Wining previousely implies the game state
}

// When all boats for a player are sunk, they lose and the game ends
pred allBoatsSunk[player: Player] {
  // Check all the ships are sunk for the player
}


