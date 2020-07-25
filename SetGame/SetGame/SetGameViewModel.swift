//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Giang Nguyenn on 7/20/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var model: SetGame = SetGameViewModel.createSetGame()
    
    private static func createSetGame() -> SetGame {
        return SetGame()
    }
    
    // MARK: - Access to Model
    var cardsShow: Array<Card> {
        model.cardsShow
    }
    
    var remainingCard: Array<Card> {
        model.remainingDeck
    }
    
    var chosenDeck: Array<Card> {
        model.potentialMatchDeck
    }
    
    // MARK: -Intents
    func choose(card: Card) {
        model.choose(card: card)
    }
    
    func newGame() {
        model = SetGameViewModel.createSetGame()
    }
    
    func dealThreeMoreCards() {
        model.dealThreeMoreCards()
    }
    
    func isASet(deck: [Card]) -> Bool {
        model.isAset(deck: deck)
    }
}

struct SetGameViewModel_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello world")
    }
}
