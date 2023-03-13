//
//  GameModel.swift
//  TicTacToe
//
//  Created by Ashborn on 12/03/23.
//

import Foundation

struct VersusAIModel {
    enum Player {
        case human, computer
    }

    struct Move {
        let player: Player
        let boardIndex: Int
        
        var indicator: String {
            return player == .human ? "xmark" : "circle"
        }
    }

}
