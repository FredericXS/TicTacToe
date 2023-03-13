//
//  Alerts.swift
//  TicTacToe
//
//  Created by Ashborn on 12/03/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"), message: Text("You are so smart. You beat the AI."), buttonTitle: Text("Oh yeah"))
    
    static let computerWin = AlertItem(title: Text("You Lost!"), message: Text("The AI is very smart. It's a super AI."), buttonTitle: Text("Rematch"))
    
    static let playerOneWin = AlertItem(title: Text("Player One Win!"), message: Text("Was a great game! Player One was the best."), buttonTitle: Text("Rematch"))
    
    static let playerTwoWin = AlertItem(title: Text("Player Two Win!"), message: Text("Was a great game! Player Two was the best."), buttonTitle: Text("Rematch"))
    
    static let draw = AlertItem(title: Text("Draw!"), message: Text("What a battle! You fought well."), buttonTitle: Text("Try again"))
}
