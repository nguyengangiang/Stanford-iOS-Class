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
    
    func body(for size: CGSize) -> some View {
        ZStack {
            if self.card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Text(card.content)
            } else {
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: cornerRadius).fill()
                }
            }
        }
        .font(Font.system(size: fontSize(for: size)))
        // .aspectRatio(2/3, contentMode: .fit)
    }
    // MARK: - Drawing Constants
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3.0
    let fontScale: CGFloat = 0.75
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height)*fontScale
    }
}


}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
