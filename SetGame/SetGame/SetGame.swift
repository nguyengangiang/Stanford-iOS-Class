//
//  SetGame.swift
//  SetGame
//
//  Created by Giang Nguyenn on 7/15/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import Foundation

struct SetGame {
    var cardsShow = [Card]()
    var remainingDeck = [Card]()
    var potentialMatchDeck = [Card]()
    
    init() {
        var tempDeck = [Card]()
        for symbol in Card.symbol.allCases {
            for color in Card.color.allCases {
                for numberOfSymbol in Card.numberOfSymbol.allCases {
                    for shading in Card.shading.allCases {
                        let newCard = Card(symbol: symbol, color: color, numberOfSymbol: numberOfSymbol, shading: shading)
                        tempDeck.append(newCard)
                    }
                }
            }
        }
        tempDeck.shuffle()
        for cards in tempDeck {
            remainingDeck.append(cards)
        }
        for index in 0..<numCardsShow{
            cardsShow.append(remainingDeck[index])
            remainingDeck.remove(at: index)
        }
    }
    
    mutating func choose (card: Card) {
        if let chosenIndex = cardsShow.firstIndex(matching: card), !cardsShow[chosenIndex].isMatched {
            // enable deselectation:
            // if the card is selected, deselect that card
            if (cardsShow[chosenIndex].isSelected && potentialMatchDeck.count < 3) {
                cardsShow[chosenIndex].isSelected = !cardsShow[chosenIndex].isSelected
                potentialMatchDeck.remove(at: potentialMatchDeck.firstIndex(matching: cardsShow[chosenIndex])!)
            } else {
                cardsShow[chosenIndex].isSelected = !cardsShow[chosenIndex].isSelected
                if (potentialMatchDeck.count < 3 && cardsShow[chosenIndex].isSelected) {
                    potentialMatchDeck.append(cardsShow[chosenIndex])
                }
                /* if three cards are chosen, check to see if they are part of a set*/
                if (potentialMatchDeck.count == 3) {
                    /* if the three cards are part of a set then remove them from the deck of cards on screen, add more from the remaining deck*/
                    if (isAset(deck: potentialMatchDeck)) {
                        for card in potentialMatchDeck {
                            let matchIndex = cardsShow.firstIndex(matching: card)!
                            cardsShow.remove(at: matchIndex)
                        }
                        for i in 0..<3 {
                            if (remainingDeck.count > 3) {
                                cardsShow.append(remainingDeck[i])
                                remainingDeck.remove(at: i)
                            }
                        }
                        potentialMatchDeck.removeAll()

                    /* if not in a set, deselect them from the deck of cards shown on screen*/
                    } else {
                        for i in 0..<3 {
                            let deselectedIndex = cardsShow.firstIndex(matching: potentialMatchDeck[i])!
                            cardsShow[deselectedIndex].isSelected = false
                        }
                        potentialMatchDeck.removeAll()
                    }
                }
            }
        }
    }
    
    // check if 3 cards chosen are a set using the logic that the
    // total hash value of a set is divisible by 3
    private func isAset(deck: [Card]) -> Bool {
        let card1 = deck[0]
        let card2 = deck[1]
        let card3 = deck[2]
        var sum = card1.id + card2.id + card3.id
        while ((sum / 10) > 1) {
            if ((sum % 10) % 3 != 0) {
                return false
            } else {
                sum /= 10
            }
        }
        return true
    }
    
    // MARK: - Constant
    let numCardsShow = 12
}


