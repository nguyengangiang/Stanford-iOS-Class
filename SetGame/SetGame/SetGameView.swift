//
//  ContentView.swift
//  SetGame
//
//  Created by Giang Nguyenn on 7/15/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: SetGameViewModel
    
    var body: some View {
        Group {
            Grid(self.viewModel.cardsShow) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.viewModel.choose(card: card)
                    }
                }
            }
            .padding(4.5)
            .transition(.offset(x: 0, y: 0))
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.viewModel.newGame()
                }
            }, label: {Text("New Game")})
            
            if (viewModel.remainingCard.count > 3) {
                Button(action: {
                    withAnimation(.easeInOut) {
                    self.viewModel.dealThreeMoreCards()}
                }, label: {Text("Deal Three More Cards")})
            }
        }
        .padding(4.5)
    }
}

struct CardView: View {
    var card: Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    private func body(for size: CGSize) -> some View {
        ZStack {
            Group {
                VStack {
                    ForEach(0..<card.numberOfSymbol.rawValue, id: \.self) {_ in
                        CardContent(card: self.card)
                            .opacity(self.shading)
                    }
                    .frame(width: size.width/2, height: size.width/4, alignment: .center)
                    .overlay(
                        CardContent(card: self.card)
                        .stroke(lineWidth: edgeLineWidth)
                    )
                    .foregroundColor(self.color)
                }
                
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.purple).opacity(0.1)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth).opacity(card.isSelected ? 1 : 0).foregroundColor(Color.yellow)
        }
        .padding(padding)
        .aspectRatio(2/3, contentMode: .fit)
    }
}
    
    var color: Color {
        let color = card.color
        switch color {
        case .red: return Color.red
        case .blue: return Color.blue
        case .green: return Color.green
        }
    }
    
    var shading: Double {
        let shading = card.shading
        switch shading {
        case .empty: return 0
        case .solid: return 1
        case .striped: return 0.5
        }
    }
    

        // MARK: -Constants
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3.0
    private let padding: CGFloat = 4.5
    private let frameWidth: CGFloat = 70
    private let frameHeight: CGFloat = 40
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        return SetGameView(viewModel: game)
    }
}

