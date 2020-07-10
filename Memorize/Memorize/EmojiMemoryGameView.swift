//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Giang Nguyenn on 6/28/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        Group {
            Text(self.viewModel.getTheme().name)
            Text(self.viewModel.displayScore())
            Grid(self.viewModel.cards) {card in
                  CardView(card: card).onTapGesture {
                      self.viewModel.choose(card: card)
                  }
              .padding(5)
            } .foregroundColor(self.viewModel.getTheme().color)
            .padding()
            
            HStack {
                Button(action: self.viewModel.newGame) {
                    Text("New Game")
                }
            }
        }
    }


struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body : some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(110 - 90), clockwise: true)
                    .padding(5).opacity(0.4)
                Text(card.content)

            } .cardify(isFaceUp: card.isFaceUp)
                // .aspectRatio(2/3, contentMode: .fill)
                .font(Font.system(size: fontSize(for: size)))
        }

    }
    // MARK: - Drawing Constants
    private let fontScale: CGFloat = 0.7
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height)*fontScale
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
}
