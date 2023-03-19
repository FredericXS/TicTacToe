//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Ashborn on 12/03/23.
//

import SwiftUI

final class VersusAIViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let levels: [String] = ["Easy", "Medium", "Hard", "Impossible"]
    
    @Published var moves: [VersusAIModel.Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    @Published var selectedLevelIndex = 0
    @Published var isGameStarted = false
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = VersusAIModel.Move(player: .human, boardIndex: position)
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameboardDisabled = true
        isGameStarted = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosistion(in: moves)
            moves[computerPosition] = VersusAIModel.Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [VersusAIModel.Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosistion(in moves: [VersusAIModel.Move?]) -> Int {
        let logicModel = GameLogicModel(currentMove: moves)
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        var movePosition: Int = 0
        
        func easyMode() -> Int {
            // Pick a random square
            logicModel.pickRandomSquare()
        }
        
        func mediumMode() -> Int {
            // Try block possible player win
            let blockPossibleWin = logicModel.blockWin(patterns: winPatterns)
            if (blockPossibleWin != -1) { return blockPossibleWin }
            
            // If there's no win to be blocked, then pick the middle square
            let middleSquare = logicModel.pickMiddleSquare()
            if (middleSquare != -1) { return middleSquare }
            
            // If AI can't pick middle square, then pick a random square
            return easyMode()
        }
        
        func hardMode() -> Int {
            // If AI can win, then win the game
            let winGame = logicModel.winGame(patterns: winPatterns)
            if (winGame != -1) { return winGame }
            
            // If AI can't win the game, then block a possible win
            return mediumMode()
        }
        
        func impossibleMode() -> Int {
            // If AI can win, then win the game
            let winGame = logicModel.winGame(patterns: winPatterns)
            if (winGame != -1) { return winGame }
            
            // If AI can't win the game, then block a possible win
            let blockPossibleWin = logicModel.blockWin(patterns: winPatterns)
            if (blockPossibleWin != -1) { return blockPossibleWin }
            
            // If there's no win to be blocked, then pick the middle square
            let middleSquare = logicModel.pickMiddleSquare()
            if (middleSquare != -1) { return middleSquare }
            
            // If AI can't pick middle square because is yours, then pick a square above the middle
            let secondSquare = logicModel.pickMiddleSquare()
            if (secondSquare != -1) { return secondSquare }
            
            // If AI can't pick middle square because is not yours, then pick a corner square
            let cornerSquare = logicModel.pickCornerSquare()
            if (cornerSquare != -1) { return cornerSquare }
            
            // If AI can't pick corner square, then pick a random square
            return easyMode()
        }
        
        switch(selectedLevelIndex) {
            case 0:
                movePosition = easyMode()
            case 1:
                movePosition = mediumMode()
            case 2:
                movePosition = hardMode()
            case 3:
                movePosition = impossibleMode()
            default:
                print("Something is wrong")
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: VersusAIModel.Player, in moves: [VersusAIModel.Move?]) -> Bool {
        // Setting Win conditions
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        // If player move == a win condition, then win
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [VersusAIModel.Move?]) -> Bool {
        // If all squares occupied, then draw
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isGameStarted = false
    }
}
