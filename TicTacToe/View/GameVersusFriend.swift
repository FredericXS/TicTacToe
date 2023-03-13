//
//  GameVersusFriend.swift
//  TicTacToe
//
//  Created by Ashborn on 12/03/23.
//

import SwiftUI

struct GameVersusFriend: View {
    @StateObject private var viewModel = VersusFriendViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Play versus your friend")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameSquareView(proxy: geometry, color: .blue)
                            
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
            }
        }
    }
}

struct GameVersusFriend_Previews: PreviewProvider {
    static var previews: some View {
        GameVersusFriend()
    }
}
