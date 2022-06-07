//
//  PartTwoViewModel.swift
//  Tic Tac Toe
//
//  Created by Amrita Pal on 7/22/21.
//

import Foundation

class TicTacToeViewModel: ObservableObject {
    @Published private var model: TicTacToeGame = TicTacToeGame(width: 5, height: 6, winLength: 3)
    
    func getBoardWidth() -> Int {
        model.board.width
    }
    
    func getNextMove() -> String {
        model.nextPiece.rawValue
    }
    
    func makeMove(position: TicTacToeGame.Board.Position) {
        model.makeMove(at: position)
    }
    
    func getPositions() -> [TicTacToeGame.Board.Position] {
        model.board.positions
    }
    
    func findWinner() -> TicTacToeGame.Board.Piece? {
        model.winner
    }
    
    func isDraw() -> Bool {
        model.board.unoccupiedPositions.isEmpty
    }
    
    func reset(width: Int, height: Int, winLength: Int) {
        model = TicTacToeGame(width: width, height: height, winLength: winLength)
    }
}
