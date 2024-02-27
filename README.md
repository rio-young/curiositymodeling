# curiositymodeling

Modeling a game of battleship
Currently the game shows five turns as a large number of turns takes a long amount of time. These can be run either by clicking the green play button in VSCode or by running the file with "racket battleship.frg".

# Project Objective: What are you trying to model? Include a brief description that would give someone unfamiliar with the topic a basic understanding of your goal.

The goal of this model is to model a possible game of Battleship. The game Battleship involves two players, each with their own board, who each place 5 ships on their boards. Then, the players take turns attempting to predict where each others ships are by calling out positions on the board. If a player guesses correctly, their opponent's ship is hit. If all positions containing ships for a player are hit, then the other player wins.

# Model Design and Visualization: Give an overview of your model design choices, what checks or run statements you wrote, and what we should expect to see from an instance produced by the Sterling visualizer. How should we look at and interpret an instance created by your spec? Did you create a custom visualization, or did you use the default?

There were a few different design choices we made that differ from an actual game of Battleship. Firstly, we made the board sizes to be 8x8 rather than the standard 10x10 boards typically found in Battleship. In regular Battleship, there are ships of size 2, 3, 3, 4, and 5. However, we chose to constrain the sizes of the ships to all be one position.
We chose to model each board as two separate pfuncs, one containing the postion of the shots and one containing the positions of the ships. This way, we could keep track of all shots, miss or hit, and also ensure that the positions of the ships did not change from turn to turn. We also created the BoardState and Game sigs which keep track of the player's boards and the progression of turns respectively.
Some of the important predicates we created are board_wellformed, init, and move. The board_wellformed predicate ensures that any shots placed on the board are at expected positions, namely ones within the range of 0-7, inclusive. The init predicate ensures that each player has indeed placed the correct number of ships on the board and that neither player has taken a turn yet. Finally, the move predicate is the one that models moves between turns, ensuring the correct player is moving at any point and that any positions that isn't the chosen position do not change.
The expected behavior from an instance would be that the first BoardState contains only boards that have not been shot at and correctly formed ships. Each BoardState should also be reachable from the first BoardState via next.
We created a custom visualizer for this model in the form of a few grids. The grids that are within the same rectangle represent a single players board, with the left grid belonging to player1 and the right grid belonging to player2. Within these grids are two smaller grids, representing the shots and the ships. The emptier grids with only T's represent the postions of the ships whereas the filled gridds represent shots, with T's representing where that board has been shot.

# Signatures and Predicates: At a high level, what do each of your sigs and preds represent in the context of the model? Justify the purpose for their existence and how they fit together.

# Testing: What tests did you write to test your model itself? What tests did you write to verify properties about your domain area? Feel free to give a high-level overview of this.
