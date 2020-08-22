//
//  MemorizeStore.swift
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
    @Published var themes = [animal, flag, scene, fruit, flag]

    func name(for theme: Theme) -> String {
        return theme.name
    }
    
    func addTheme(named name: String = "Untitled") {
        let newTheme = defaultTheme
        themes.append(newTheme)
    }
    
    func removeTheme(_ theme: Theme) {
        themes.remove(at: themes.firstIndex(matching: theme)!)
    }
    
    init(named name: String = "Memory Game") {
        self.name = name
        let defaultsKey = "MemorizeStore.\(name)"
        
    }
}

