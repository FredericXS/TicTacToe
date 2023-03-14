//
//  GameVersusAIView.swift
//  TicTacToe
//
//  Created by Ashborn on 12/03/23.
//

import SwiftUI

struct GameVersusAIView: View {
    @StateObject private var viewModel = VersusAIViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Play versus the computer")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                HStack {
                    Text("Choose the difficult: ")
                        .font(.title3)
                    Picker(selection: $viewModel.selectedLevelIndex, label: Text("")) {
                        ForEach(0..<viewModel.levels.count) {
                            Text(viewModel.levels[$0])
                                }
                             }
                    .disabled(viewModel.isGameStarted)
                }
                .padding(.vertical, 30)
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameSquareView(proxy: geometry, color: .red)
                            
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameVersusAIView()
    }
}
