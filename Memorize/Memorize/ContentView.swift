//
//  ContentView.swift
//  Memorize
//
//  Created by Giang Nguyenn on 6/28/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var viewModel: EmojiMemoryGame
    
    var body: some View {
        HStack {
            ForEach(viewModel.cards) {card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
            }
        }
        .padding()
        .foregroundColor(Color.orange)
        .font(self.viewModel.cards.count == 10 ? Font.footnote : Font.largeTitle)

    }
}


struct CardView : View {
    var card: MemoryGame<String>.Card
    var body : some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
