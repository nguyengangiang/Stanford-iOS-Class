//
//  MemoryGameChooser.swift
//  Memorize
//
//  Created by Giang Nguyenn on 8/21/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

struct MemoryGameChooser: View {
    @EnvironmentObject var store: ThemeStore
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) {theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))
                        .navigationBarTitle(self.store.name(for: theme)))
                    {
                        EditableText(self.store.name(for: theme), isEditing: self.editMode.isEditing) { name in
                            self.store.themes[self.store.themes.firstIndex(matching: theme)!].setName(name)
                        }
                    }
                }
                .onDelete{ indexSet in
                    indexSet.map { self.store.themes[$0]}.forEach { theme in
                        self.store.removeTheme(theme: theme)
                    }
                }
            }
            navigationBarTitle(self.store.name)
                .navigationBarItems(leading: Button( action: {
                    self.store.addTheme()
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }),
                trailing: EditButton()
            )
                .environment(\.editMode, $editMode)
        }
    }
}

struct MemoryGameChooser_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameChooser()
    }
}
