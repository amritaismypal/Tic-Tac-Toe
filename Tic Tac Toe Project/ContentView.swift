//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Amrita Pal on 7/22/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: TicTacToeViewModel
    @State var gameID = UUID()
    var body: some View {
        ZStack {
            Spacer()
            TitleView()
            Spacer()
            OnScreenBoard(viewModel: viewModel)
                .id(gameID)
                .padding()
            GameOver(viewModel: viewModel)
            Spacer()
            VStack {
                Spacer(minLength: 700)
                Button("Reset") { viewModel.reset(width: 5, height: 6, winLength: 3)
                    gameID = UUID()
                }
                    .font(.system(size: 25.0))
                    .padding(.all, 5)
                    .background(Color.white)
                    .cornerRadius(12)
                    .foregroundColor(.black)
                Spacer()
            }
        }
    }
}

struct TitleView: View {
    var body: some View {
        VStack {
            Text("Tic Tac Toe")
            .font(.system(size: 40))
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

struct OnScreenBoard: View {
    @ObservedObject var viewModel: TicTacToeViewModel
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: viewModel.getBoardWidth())) {
            ForEach(viewModel.getPositions()) { pos in
                CircleView(viewModel: viewModel, pos: pos)
            }
        }
    }
}

struct CircleView: View {
    @ObservedObject var viewModel: TicTacToeViewModel
    @State var piece: String = ""
    @State var clicked: Bool = false
    @State var pos: TicTacToeGame.Board.Position
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.gray)
                .onTapGesture(perform: {
                    if viewModel.findWinner() == nil && !viewModel.isDraw() && !clicked {
                        piece = viewModel.getNextMove()
                        viewModel.makeMove(position: pos)
                        clicked = true
                    }
                }).aspectRatio(1.0, contentMode: .fill)
            if piece == "X"  {
                XView()
            }
            if piece == "O"  {
                OView()
            }
        }
    }
}

struct OView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.addEllipse(in: geometry.frame(in: .local))
            }.stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round))
        }
    }
}

struct XView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to:
                    CGPoint(
                        x: geometry.size.width * 0.18,
                        y: geometry.size.height * 0.18
                    )
                )
                path.addLine(to:
                    CGPoint(
                        x: geometry.size.width * 0.82,
                        y: geometry.size.height * 0.82
                    )
                )
                path.move(to:
                    CGPoint(
                        x: geometry.size.width * 0.18,
                        y: geometry.size.height * 0.82
                    )
                )
                path.addLine(to:
                    CGPoint(
                        x: geometry.size.width * 0.82,
                        y: geometry.size.height * 0.18
                    )
                )
            }.stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round))
        }
    }
}


struct GameOver: View {
    @ObservedObject var viewModel: TicTacToeViewModel
    var body: some View {
                VStack {
                    Spacer()
                    if viewModel.isDraw() {
                        RoundedRectangle(cornerRadius: 12)
                            .aspectRatio(2.0, contentMode: .fit)
                            .foregroundColor(.blue)
                            .overlay(
                        Text("Draw")
                            .font(.system(size: 60))
                            .fontWeight(.semibold)
                            ).padding(50)
                    }
                    if let winner = viewModel.findWinner() {
                        RoundedRectangle(cornerRadius: 12)
                            .aspectRatio(2.0, contentMode: .fit)
                            .foregroundColor(.blue)
                            .overlay(
                        Text("\(winner.rawValue) wins!")
                            .font(.system(size: 60))
                            .fontWeight(.semibold)
                            ).padding(50)
                    }
                    Spacer()
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(viewModel: TicTacToeViewModel())
        }
    }
}
