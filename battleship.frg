#lang forge/bsl

abstract sig Boolean {}
one sig True, False extends Boolean {}

sig Game {
  first: BoardState,
  next: pfunc BoardState -> BoardState,
}

sig BoardState {
  player1: one Player,
  player2: one Player,
}

sig Player {
  playerBoard: one Board
} 

one sig player1, player2 extends Player {} 

sig Board {
    //should all be false initially, true means the other player shot at that postion
    shots: pfunc Int -> Int -> Boolean,
    ships: pfunc Int -> Int -> Ship
}

// Init state of the game - Rio
pred init {
  // True for both players
  // Board needs to all be false
  // 5 ships for each player
  // All 5 shapes for each player
  // All ships are not sunk
}

// Two 10 x 10 boards, one for each player - John
pred board_wellformed {
  // Player shots have to be 0-9
  // Player ships have to be 0-9
  // Check no ships are overlapping
}

// 5 ships each of sizes 5, 4, 3, 3, 2
sig Ship{
  size: one Int,
  isSunk: one Boolean,
  //Everything but ship should be null, initially all places in ship should be False
  // shipHit: pfunc Int -> Int -> Boolean
}
// All ships must be placed on the board, and must be placed horizontally or vertically - John
pred ship_wellformed[ship: Ship] {
  // Align horizonally or vertically if > 1
  // Size = to number of positions

  // Check if ship is sunk - Rio
    // If for each existance on the board there is a shot on the baord
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


