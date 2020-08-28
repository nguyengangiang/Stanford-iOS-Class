//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Giang Nguyenn on 6/30/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    @Published private var theme: Theme
//    init(theme: Theme) {
//        self.theme = theme
//        self.model = EmojiMemoryGame.createMemoryGame(theme: theme)
//    }
    
//    static func == (lhs: EmojiMemoryGame, rhs: EmojiMemoryGame) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    let id: UUID
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }

    private var autosaveCancellable: AnyCancellable?

    init(theme: Theme) {
        self.model = EmojiMemoryGame.createMemoryGame(theme: theme)
        let defaultsKey = "EmojiMemoryGame.State"
        self.theme = Theme(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? theme
        autosaveCancellable = $theme.sink {theme in
            UserDefaults.standard.set(theme.json, forKey: defaultsKey)
        }
    }
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        return MemoryGame<String>(theme: theme, numberOfPairsOfCards: theme.numberOfCardsShow) {pairIndex in
            return theme.emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    //MARK: - Intent(s
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func getTheme() -> Theme {
        return model.getTheme()
    }
    
    func displayScore() -> String{
        return String(model.displayScore())
    }
    
    func newGame(theme: Theme) {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}

struct EmojiMemoryGame_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

