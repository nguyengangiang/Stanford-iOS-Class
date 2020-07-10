//
//  MemoryGame.swift
//  Memorize
//
//  Created by Giang Nguyenn on 6/30/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import Foundation
import SwiftUI

//
//  MemoryGame.swift
//  Memorize
//
//  Created by Giang Nguyenn on 6/30/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    var cards: Array<Card>
    var theme: Theme
    var score: Int
    
    private(set) var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter {cards[$0].isFaceUp}.only
        } set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(matching: card),
            !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else {
                    if cards[chosenIndex].isSeen && cards[potentialMatchIndex].isSeen {
                        score -= 2
                    } else if cards[chosenIndex].isSeen || cards[potentialMatchIndex].isSeen{
                        score -= 1
                    }
                    cards[chosenIndex].isSeen = true
                    cards[potentialMatchIndex].isSeen = true
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    init(theme: Theme, numberOfPairsOfCards: Int, cardContentFactory:(Int) -> CardContent) {
        cards = Array<Card>()
        score = 0
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
        self.theme = theme
    }
    
    func getTheme() -> Theme{
        return theme
    }
    
    func getThemeColor() -> Color {
        return theme.color
    }
    
    func displayScore() -> Int {
        return score
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isSeen: Bool = false
        var content: CardContent
        var id: Int
    }
}
