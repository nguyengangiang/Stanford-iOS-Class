//
//  SetGame.swift
//  SetGame
//
//  Created by Giang Nguyenn on 7/15/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import Foundation

class SetGame {
    var totalDeck = [Card]()
    var cardsShow = [Card]()
    var remainingDeck = [Card]()
    
    init() {
        var tempDeck = [Card]()
        for symbol in Card.symbol.allCases {
            for color in Card.color.allCases {
                for numberOfSymbol in Card.numberOfSymbol.allCases {
                    for shading in Card.shading.allCases {
                        let newCard = Card(symbol: symbol.rawValue, color: color.rawValue, numberOfSymbol: numberOfSymbol.rawValue, shading: shading.rawValue)
                        tempDeck.append(newCard)
                    }
                }
            }
        }
        tempDeck.shuffle()
        for cards in tempDeck {
            totalDeck.append(cards)
            remainingDeck.append(cards)
        }
        for index in 0..<numCardsShow{
            cardsShow.append(remainingDeck[index])
            remainingDeck.remove(at: index)
        }
    }
}


// MARK: - Constant
let numCardsShow = 12
