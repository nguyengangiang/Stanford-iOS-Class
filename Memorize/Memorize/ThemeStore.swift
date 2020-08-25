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
    let name: String
    private var autosave: AnyCancellable?
    @Published var theme: Theme
    
    private var halloween = Theme(emojis:["👻", "👺", "💀", "🕷", "🎃"], name: "Halloween", color: UIColor.RGB(red: 255, green: 165, blue: 0, alpha: 255))
    private var animal =  Theme(json: UserDefaults.standard.data(forKey: ThemeStore.untitled)) ?? Theme(emojis: [ "🦚", "🐗", "🦕", "🦧", "🦔"], name: "Animal", color: UIColor.RGB(red: 0, green: 0, blue: 200, alpha: 255))
    private var sport =  Theme(json: UserDefaults.standard.data(forKey: ThemeStore.untitled)) ??  Theme(emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏸"], name: "Sport", color: UIColor.RGB(red: 0, green: 200, blue: 0, alpha: 255))
    private var scene =  Theme(json: UserDefaults.standard.data(forKey: ThemeStore.untitled)) ??  Theme(emojis: ["🏙", "🎇", "🌃", "🌌", "🌁", "🌉"], name: "Scenery", color: UIColor.RGB(red: 127, green: 0, blue: 128, alpha: 255))
    private var fruit =  Theme(json: UserDefaults.standard.data(forKey: ThemeStore.untitled)) ?? Theme(emojis:["🥝", "🍇", "🍉", "🥭"], name: "Fruit", color: UIColor.RGB(red: 0, green: 100, blue: 50, alpha: 255))
    private var flag =  Theme(json: UserDefaults.standard.data(forKey: ThemeStore.untitled)) ?? Theme(emojis:["🇫🇷", "🇷🇺", "🇹🇭", "🇱🇺", "🇳🇱"], name: "Flag", color: UIColor.RGB(red: 200, green: 0, blue: 0, alpha: 250))

    let defaultTheme = Theme(emojis: ["😀", "😂", "😭"], name: "Untitled", color: UIColor.RGB(red: 255, green: 165, blue: 0, alpha: 255))
    
    @Published var themes : [Theme]
    private static let untitled = "MemoryStore.Untitled"

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
        let newTheme = Theme(emojis: defaultTheme.emojis, name: defaultTheme.name, color: defaultTheme.color)
        themes.append(newTheme)
    }
    
    func removeTheme(theme: Theme) {
        themes.remove(at: themes.firstIndex(matching: theme)!)
    }
    
    init(named name: String = "Memory Game") {
        self.name = name
        let defaultsKey = "ThemeStore.\(name)"
        themes = [animal, flag, scene, fruit, sport, halloween]
        theme = Theme(json: UserDefaults.standard.data(forKey: ThemeStore.untitled)) ?? Theme(emojis: ["😀", "😂", "😭"], name: "Untitled", color: UIColor.RGB(red: 255, green: 165, blue: 0, alpha: 255))
        autosave = $themes.sink {_ in
            UserDefaults.standard.set(self.theme.json, forKey: defaultsKey)
        }
    }
}

