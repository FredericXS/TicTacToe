//
//  GameFriendModel.swift
//  TicTacToe
//
//  Created by Ashborn on 12/03/23.
//

import Foundation

struct VersusFriendModel {
    enum Player {
        case playerOne, playerTwo
    }

    struct Move {
        let player: Player
        let boardIndex: Int
        
        var indicator: String {
            return player == .playerOne ? "xmark" : "circle"
        }
    }
}
