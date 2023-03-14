//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Ashborn on 12/03/23.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                GameVersusFriend()
                    .tabItem {
                        Label("VS Friend", systemImage: "person.2.fill")
                    }
                GameVersusAIView()
                    .tabItem {
                        Label("VS Computer", systemImage: "bonjour")
                    }
            }
        }
    }
}
