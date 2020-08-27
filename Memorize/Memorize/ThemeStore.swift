//
//  ThemeStore.swift
//  Memorize
//
//  Created by Giang Nguyenn on 8/20/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI
import Combine

class ThemeStore: ObservableObject {
    let name: String = "EmojiMemoryGame"
    private var autosave: AnyCancellable?
    // private static let untitled = "MemoryStore.Untitled"

    static var halloween = Theme(emojis:["👻", "👺", "💀", "🕷", "🎃"], name: "Halloween", color: UIColor.RGB(red: 255, green: 15, blue: 0, alpha: 255))
    static var animal =  Theme(emojis: [ "🦚", "🐗", "🦕", "🦧", "🦔"], name: "Animal", color: UIColor.RGB(red: 0, green: 0, blue: 200, alpha: 255))
    static var sport = Theme(emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏸"], name: "Sport", color: UIColor.RGB(red: 0, green: 200, blue: 0, alpha: 255))
    static var scene =  Theme(emojis: ["🏙", "🎇", "🌃", "🌌", "🌁", "🌉"], name: "Scenery", color: UIColor.RGB(red: 127, green: 0, blue: 128, alpha: 255))
    static var fruit =  Theme(emojis:["🥝", "🍇", "🍉", "🥭"], name: "Fruit", color: UIColor.RGB(red: 0, green: 100, blue: 50, alpha: 255))
    static var flag =  Theme(emojis:["🇫🇷", "🇷🇺", "🇹🇭", "🇱🇺", "🇳🇱"], name: "Flag", color: UIColor.RGB(red: 200, green: 0, blue: 0, alpha: 250))

    @Published var themes : [Theme]
    

    func name(for theme: Theme) -> String? {
        if (themes.contains(theme)) {
            return theme.name
        } else {
            return nil
        }
    }
    
    func setName(_ theme: Theme, name: String) {
        if (themes.contains(theme)) {
            themes[themes.firstIndex(matching: theme)!].setName(name: name)
        }
    }
    
    func addTheme(named name: String = "Untitled") {
        let newTheme = Theme()
        themes.append(newTheme)
    }
    
    func removeTheme(theme: Theme) {
        themes.remove(at: themes.firstIndex(matching: theme)!)
    }
    
    func json<T: Encodable>( themeList : T) ->Data  {
        var json : Data
        // encode the theme List into json
        do {
            let encoder = JSONEncoder()
            json = try encoder.encode(themeList)
        } catch {
            fatalError("Couldn't encode themeList as \(T.self):\n\(error)")
        }
        return json
    }
    
    init() {
        let defaultsKey = "MemorizeStore.\(name)"
        let json = UserDefaults.standard.data(forKey: defaultsKey)
        if json != nil, let newThemeList = try? JSONDecoder().decode([Theme].self, from: json!) {
            self.themes = newThemeList
        } else {
            self.themes = [ThemeStore.halloween, ThemeStore.animal, ThemeStore.flag, ThemeStore.fruit, ThemeStore.scene, ThemeStore.sport]
        }
        autosave = $themes.sink {theme in
            let t = self.json(themeList: theme)
            UserDefaults.standard.set(t, forKey: defaultsKey)
            print(t.utf8 as Any)
            print(defaultsKey)
        }
    }
}


