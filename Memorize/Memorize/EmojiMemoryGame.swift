//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Giang Nguyenn on 6/30/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    

    static func createMemoryGame() -> MemoryGame<String> {
        let theme = themes[Int.random(in: 0...5)]
        return MemoryGame<String>(theme: theme, numberOfPairsOfCards: theme.numberOfCardsShow!) {pairIndex in
            return theme.emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    //MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func getTheme() -> Theme {
        model.getTheme()
    }
    
    func displayScore() -> String{
        String(model.displayScore())
    }
    func newGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}

struct EmojiMemoryGame_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}


