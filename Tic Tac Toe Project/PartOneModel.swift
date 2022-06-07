//
//  PartOneModel.swift
//  Tic Tac Toe
//
//  Created by Amrita Pal on 7/22/21.
//

import Foundation

struct TicTacToeGame {
    
    struct Board {
        struct Position: Hashable, Identifiable {
            var row: Int
            var column: Int
            var id: Int
        }
        
        enum Piece: String {
            case x = "X" // this means Piece.x.rawValue == "X"
            case o = "O"
        }
        
        func other(_ p : Piece) -> Piece {
            switch p {
            case .x:
                return Piece.o
            case .o:
                return Piece.x
            }
        }
        
        let width: Int
        let height: Int
        var posMap: Dictionary<Position, Piece>
        
        // TODO: Data representation of game board
        init(width: Int, height: Int) {
            self.width = width
            self.height = height
            posMap = [:]
        }
        
        func piece(at p: Position) -> Piece? {
            return posMap[p]
        }
        
        mutating func putPiece(_ piece: Piece, at pos: Position) {
            posMap[pos] = piece
        }
        
        var positions: [Position] {
            var out: [Position] = []
            for i in 0..<height {
                for j in 0..<width {
                    out.append(Position(row: i, column: j, id: i * width + j))
                }
            }
            return out
        }

        var occupiedPositions: [Position] { return Array(posMap.keys) }
        var unoccupiedPositions: [Position] { return positions.filter(
            { !occupiedPositions.contains($0) }
        )}
    }
    
    let winLength: Int
    var board: Board
    var nextPiece: Board.Piece = Board.Piece.x
    
    init(width: Int, height: Int, winLength: Int) {
        assert(width > 0)
        assert(height > 0)
        assert(winLength > 0 && winLength <= min(width, height))
        self.winLength = winLength
        board = Board(width: width, height: height)
    }
    
    mutating func makeMove(at pos: Board.Position) {
        board.putPiece(nextPiece, at: pos)
        nextPiece = board.other(nextPiece)
    }
    
    var winner: Board.Piece? {
        func rowWinner() -> Board.Piece? {
            func rowWinner(at : Int) -> Board.Piece? {
                func rowWinner(at row: Int, startingOn col: Int) -> Board.Piece? {
                    var xCount = 0, oCount = 0
                    for j in col..<(col + winLength) {
                        if let p = board.piece(at: Board.Position(row: row, column: j, id: row * board.width + j)) {
                            switch p {
                            case Board.Piece.x:
                                xCount += 1
                            case Board.Piece.o:
                                oCount += 1
                            }
                        }
                    }
                    if xCount == winLength {
                        return Board.Piece.x
                    }
                    if oCount == winLength {
                        return Board.Piece.o
                    }
                    return nil
                }
                for j in 0..<board.width {
                    if let winner = rowWinner(at: at, startingOn: j) {
                        return winner
                    }
                }
                return nil
            }
            for i in 0..<board.height {
                if let winner = rowWinner(at: i) {
                    return winner
                }
            }
            return nil
        }
        
        func colWinner() -> Board.Piece? {
            func colWinner(at : Int) -> Board.Piece? {
                func colWinner(at col: Int, startingOn row: Int) -> Board.Piece? {
                    var xCount = 0, oCount = 0
                    for i in row..<(row + winLength) {
                        if let p = board.piece(at: Board.Position(row: i, column: col, id: i * board.width + col)) {
                            switch p {
                            case Board.Piece.x:
                                xCount += 1
                            case Board.Piece.o:
                                oCount += 1
                            }
                        }
                    }
                    if xCount == winLength {
                        return Board.Piece.x
                    }
                    if oCount == winLength {
                        return Board.Piece.o
                    }
                    return nil
                }
                for i in 0..<board.height {
                    if let winner = colWinner(at: at, startingOn: i) {
                        return winner
                    }
                }
                return nil
            }
            for i in 0..<board.width {
                if let winner = colWinner(at: i) {
                    return winner
                }
            }
            return nil
        }
        
        func diagWinner() -> Board.Piece? {
            // Calculates if there is a winner starting at a specific row and column going either diagonally up or diagonally down
            func diagWinner(row: Int, column: Int, up: Bool) -> Board.Piece? {
                var xCount = 0
                var oCount = 0
                for idx in 0..<winLength {
                    let newRow = up ? row - idx : row + idx
                    let newCol = column + idx
                    if let p = board.piece(at: Board.Position(row: newRow, column: newCol, id: newRow * board.width + newCol)) {
                        switch p {
                        case Board.Piece.x:
                            xCount += 1
                        case Board.Piece.o:
                            oCount += 1
                        }
                    }
                }
                if xCount == winLength {
                    return Board.Piece.x
                }
                if oCount == winLength {
                    return Board.Piece.o
                }
                return nil
            }
            for i in 0..<board.height {
                for j in 0..<board.width {
                    if let winner = diagWinner(row: i, column: j, up: true) ?? diagWinner(row: i, column: j, up: false) {
                        return winner
                    }
                }
            }
            return nil
        }
        return rowWinner() ??
               colWinner() ??
               diagWinner()
    }
}
