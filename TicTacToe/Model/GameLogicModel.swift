//
//  GameLogicModel.swift
//  TicTacToe
//
//  Created by Ashborn on 18/03/23.
//

import Foundation

struct GameLogicModel {
    private(set) var moves: [VersusAIModel.Move?]
    private var aiVM: VersusAIViewModel
    private var humanMoves: [VersusAIModel.Move]
    private var computerMoves: [VersusAIModel.Move]
    
    init(currentMove: [VersusAIModel.Move?]) {
        moves = currentMove
        aiVM = VersusAIViewModel()
        
        // Get human positions to block
        humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        
        // Get computer positions to win
        computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
    }
    
    func pickRandomSquare() -> Int {
        var randomPosition = Int.random(in: 0..<9)
        
        // If square is occupied, pick any other
        while aiVM.isSquareOccupied(in: moves, forIndex: randomPosition) {
            randomPosition = Int.random(in: 0..<9)
        }
        
        return randomPosition
    }
    
    func pickMiddleSquare() -> Int {
        let centerSquare = 4
        if !aiVM.isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        return -1
    }
    
    func pickSecondSquare() -> Int {
        let secondSquare = 1 // 1 is the second square in array [0, 1, 2...]
        if !aiVM.isSquareOccupied(in: moves, forIndex: secondSquare) {
            if moves.contains(where: { $0?.boardIndex == 4 && $0?.player == .computer }) {
                return secondSquare
            }
        }
        
        return -1
    }
    
    func pickCornerSquare() -> Int {
        let corners: [Int] = [0, 2, 6, 8]
        for corner in corners {
            if !aiVM.isSquareOccupied(in: moves, forIndex: corner) {
                return corner
            }
        }
        
        return -1
    }
    
    func blockWin(patterns: Set<Set<Int>>) -> Int {
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in patterns {
            let blockPositions = pattern.subtracting(humanPositions)
            
            if blockPositions.count == 1 {
                let isBlockable = !aiVM.isSquareOccupied(in: moves, forIndex: blockPositions.first!)
                if isBlockable { return blockPositions.first! }
            }
        }
        
        return -1
    }
    
    func winGame(patterns: Set<Set<Int>>) -> Int {
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in patterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !aiVM.isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        return -1
    }
}
