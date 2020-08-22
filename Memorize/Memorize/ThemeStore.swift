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
    @Published var themes = [animal, flag, scene, fruit, sport, halloween]
    private static let untitled = "MemoryStore.Untitled"

    func name(for theme: Theme) -> String {
        return theme.name
    }
    
    func addTheme(named name: String = "Untitled") {
        let newTheme = defaultTheme
        themes.append(newTheme)
    }
    
    func removeTheme(theme: Theme) {
        themes.remove(at: themes.firstIndex(matching: theme)!)
    }
    
    init(named name: String = "Memory Game") {
        self.name = name
        let defaultsKey = "ThemeStore.\(name)"
        let theme = Theme(json: UserDefaults.standard.data(forKey: ThemeStore.untitled)) ?? themes[Int.random(in: 0...5)]
        autosave = $themes.sink {_ in
            UserDefaults.standard.set(theme.json, forKey: defaultsKey)
        }
    }
}

