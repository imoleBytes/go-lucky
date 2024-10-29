# BLOCKCHAIN JOURNEY STARTS HERE

## Description of Project Go Lucky Contract

The Lucky Game Contract is a decentralized application built on the Stacks blockchain that allows players to join a game by staking tokens. The contract manages participants, tracks their stakes, and selects a winner once the player limit is reached. This project demonstrates the use of Clarity smart contracts for creating a simple gaming application.

## Features
Join Game: Players can join the game by staking a specified amount of tokens.
Participant Management: The contract keeps track of all participants and their stakes.
Winner Selection: Once the player limit is reached, the contract can randomly select a winner and distribute prizes.

- Game Reset: After awarding the winner, the game state resets for new participants.
Constants
- TOKEN-ADDRESS: The address of the token used for staking (to be replaced with the actual token address).
- CONTRACT-OWNER: The address of the contract owner (to be replaced with the actual owner address).
- GAME-FEE: The fee taken from the total prize pool (default is 2000).
- STAKE-REQUIREMENT: The amount of tokens required to join the game (default is 100).
- PLAYER-LIMIT: The maximum number of players allowed in the game (default is 100).

## Data Structures
- Participants Map: A map that stores each participant's address, their staked amount, and whether they are active.
- Total Participants Variable: A variable that tracks the total number of participants currently in the game.

## Functions

- join-game
Allows players to join the game by checking if they have enough tokens, if the player limit has not been reached, and if they are not already participating. If all conditions are met, it transfers tokens to the contract and registers the participant.
- close-game-and-award-winner
This function can only be called by the contract owner. It checks if the game is full, validates a provided random index, calculates prizes, selects a winner from participants, and resets the game state.

## Usage

- Deploy Contract: Deploy this Clarity contract on the Stacks blockchain.
- Join Game: Players call join-game to participate by staking tokens.
- Close Game: Once 100 players have joined, the owner can call close-game-and-award-winner with a valid random index to select a winner.
- Game Reset: After awarding prizes, the game resets automatically for new players.

## Requirements
- Stacks blockchain environment
- Clarity programming language knowledge
- Access to a token that complies with Stacks' fungible token standard

