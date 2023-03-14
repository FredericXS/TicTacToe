//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Ashborn on 12/03/23.
//

import SwiftUI

final class VersusAIViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let levels: [String] = ["Easy", "Medium", "Hard"]
    
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
        // Setting Win conditions
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        var movePosition: Int = 0
        
        func easyMode() -> Int {
            // Pick a random square
            var movePosition = Int.random(in: 0..<9)
            
            while isSquareOccupied(in: moves, forIndex: movePosition) {
                movePosition = Int.random(in: 0..<9)
            }
            
            return movePosition
        }
        
        func mediumMode() -> Int {
            // Try pick the middle square
            let centerSquare = 4
            if !isSquareOccupied(in: moves, forIndex: centerSquare) {
                return centerSquare
            }
            
            // If AI can't pick middle square, then pick a random square
            return easyMode()
        }
        
        func hardMode() -> Int {
            // Win variables
            let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
            let computerPositions = Set(computerMoves.map { $0.boardIndex })
            
            // Block variables
            let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
            let humanPositions = Set(humanMoves.map { $0.boardIndex })
            
            for pattern in winPatterns {
                let winPositions = pattern.subtracting(computerPositions)
                let blockPositions = pattern.subtracting(humanPositions)
                
                if winPositions.count == 1 {
                    // If AI can win, then win
                    let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                    if isAvailable { return winPositions.first! }
                } else if blockPositions.count == 1 {
                    // If AI can't win, then block
                    let isBlockable = !isSquareOccupied(in: moves, forIndex: blockPositions.first!)
                    if isBlockable { return blockPositions.first! }
                }
            }
            
            // If AI can't win and can't block, then try pick middle square
            return mediumMode()
        }
        
        switch(selectedLevelIndex) {
            case 0:
                movePosition = easyMode()
            case 1:
                movePosition = mediumMode()
            case 2:
                movePosition = hardMode()
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
