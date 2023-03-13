//
//  DesignView.swift
//  TicTacToe
//
//  Created by Ashborn on 12/03/23.
//

import SwiftUI

struct GameSquareView: View {
    var proxy: GeometryProxy
    var color: Color?
    
    var body: some View {
        Circle()
            .foregroundColor(color!).opacity(0.5)
            .frame(width: proxy.size.width / 3 - 15, height: proxy.size.width / 3 - 15)
    }
}

struct PlayerIndicator: View {
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
