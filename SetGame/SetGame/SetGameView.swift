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
            Button(action: {
                withAnimation(.easeInOut(duration: 1)) {
                    self.viewModel.newGame()
                }
            }, label: {Text("New Game")})
            
            GeometryReader { geometry in
                Grid(self.viewModel.cardsShow) { card in
                    CardView(card: card, chosenCardCount: self.viewModel.chosenDeck.count).onTapGesture {
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.viewModel.choose(card: card)
                        }
                    }
                    .transition(.offset(x: 0, y: geometry.size.height))
                }
                .padding(4.5)
                .onAppear() {
                    withAnimation(.easeOut(duration: 1)) {
                        self.viewModel.newGame()
                    }
                }
            }
            
            
            if (self.viewModel.remainingCard.count > 3) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.viewModel.dealThreeMoreCards()
                    }
                }, label: {Text("Deal Three More Cards")})
                .offset(x: 0, y: 0)
            }
        }
    }
}


struct CardView: View {
    var card: Card
    var chosenCardCount: Int
        
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    private func body(for size: CGSize) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.purple).opacity(0.1)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth).opacity(card.isSelected ? 1 : 0).foregroundColor(Color.yellow)
                RoundedRectangle(cornerRadius: cornerRadius).foregroundColor(card.isMatched ? Color.blue : Color.red)
                    .opacity(card.isSelected && chosenCardCount == 3 ? 0.5 : 0)
               
                VStack {
                    ForEach(0..<card.numberOfSymbol.rawValue, id: \.self) {_ in
                        CardContent(card: self.card)
                            .opacity(self.shading)
                    }
                    .overlay(
                        CardContent(card: self.card)
                        .stroke(lineWidth: edgeLineWidth)
                    )
                    .foregroundColor(self.color)
                    .frame(width: size.width/2, height: size.height/4, alignment: .center)
                }
                .padding(padding)
                .scaleEffect(2/3)

        }
        .aspectRatio(2/3, contentMode: .fit)
        .padding(padding)
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
    private let padding: CGFloat = 4
    private let frameWidth: CGFloat = 70
    private let frameHeight: CGFloat = 40
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        return SetGameView(viewModel: game)
    }
}

