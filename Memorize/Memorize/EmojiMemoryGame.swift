//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Giang Nguyenn on 6/30/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame {
    private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["👻", "👺", "💀", "🕷", "🎃"]
        let numberOfPairsOfCards = Int.random(in: 2...5)
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairsOfCards) {pairIndex in
            return emojis[pairIndex]
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
    
}
