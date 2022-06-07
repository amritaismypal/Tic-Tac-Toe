//
//  Tic_Tac_ToeApp.swift
//  Tic Tac Toe
//
//  Created by Amrita Pal on 7/22/21.
//

import SwiftUI

@main
struct Tic_Tac_ToeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: TicTacToeViewModel())
        }
    }
}
