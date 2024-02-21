#lang forge/bsl


sig Board {
    //should all be false initially, true means the other player shot at that postion
    board: pfunc Int -> Int -> Boolean
}

sig Player {
  board: one Board
} 

one sig player1, player2 extends Player {} 

// Two 10 x 10 boards, one for each player
pred board_wellformed{}

// 5 ships each of sizes 5, 4, 3, 3, 2
sig Ship{
  size: one Int,
  //Everything but ship should be null, initially all places in ship should be False
  shipHit: pfunc Int -> Int -> Boolean
}
// All ships must be placed on the board, and must be placed horizontally or vertically
pred ship_wellformed{}

// Go turn by turn
// Each turn is either a hit or miss
  // Hit: the position corresponds to a ship on the other players board
  // Miss: does not hit
pred move{}

// When all positions on boat are hit, the ship is sunk
pred shipSunk{}

// When all boats for a player are sunk, they lose and the game ends
pred allBoatsSunk[player: Player]


