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
    @State private var showPaletteEditor = false
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) {theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))
                        .navigationBarTitle(self.store.name(for: theme) ?? ""))
                    {
                        Image(systemName: "pencil.circle.fill").accessibility(hidden: self.editMode == .inactive).frame(width: self.editMode == .inactive ? 0 : 2, height: self.editMode == .inactive ? 0 : 2).opacity(self.editMode == .inactive ? 0 : 1)
                            .imageScale(.large).foregroundColor(Color(theme.color))
                        .onTapGesture {
                            if (self.editMode == .active) {
                                self.showPaletteEditor = true
                            }
                        }
                        .popover(isPresented: self.$showPaletteEditor) {
                            ThemeEditor(chosenTheme: self.$store.themes[self.store.themes.firstIndex(matching: theme)!], isShowing: self.$showPaletteEditor)
                                            .environmentObject(self.store)
                                            .frame(minWidth: 300, minHeight: 500)
                        }
                        EditableText(self.store.name(for: theme) ?? "", isEditing: self.editMode.isEditing) { name in
                            self.store.themes[self.store.themes.firstIndex(matching: theme)!].setName(name)
                        }
                        Text("\(theme.cardShow()) pairs of \(theme.emojiString())")
                    }
                }
                .onDelete{ indexSet in
                    indexSet.map { self.store.themes[$0]}.forEach { theme in
                        self.store.removeTheme(theme: theme)
                    }
                }
            }
            .navigationBarTitle(self.store.name)
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

struct ThemeEditor: View {
    @EnvironmentObject var store: ThemeStore
    @Binding var chosenTheme: Theme
    @Binding var isShowing: Bool
    @State private var themeName: String = ""
    @State private var emojisToAdd: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
               Text("Paletter Editor").font(.headline).padding()
               HStack {
                   Spacer()
                   Button(action: {
                       self.isShowing = false
                   }, label: {Text("Done")}).padding()
               }
           }
            Divider()
            Form {
               Section {
                   TextField("Palette Name", text: $themeName, onEditingChanged: {
                       began in
                       if !began {
                           self.store.themes[self.store.themes.firstIndex(matching: self.chosenTheme)!].setName(self.themeName)

                       }
                   })
                   TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: {
                       began in
                       if !began {
                        for ch in self.emojisToAdd {
                            self.store.themes[self.store.themes.firstIndex(matching: self.chosenTheme)!].addEmoji(emoji:String(ch))
                        }
                           self.emojisToAdd = ""
                       }
                   })
               }
               Section(header: Text("Remove Emoji")) {
                Grid(chosenTheme.emojis, id: \.self) { emoji in
                       Text(emoji).font(Font.system(size: self.fontSize))
                           .onTapGesture {
                            self.store.themes[self.store.themes.firstIndex(matching: self.chosenTheme)!].removeEmoji(emoji: emoji)
                       }
                   }
                   .frame(height: self.height)
               }
                Section(header: Text("Card Count")) {
                    HStack {
                        Text("\(self.chosenTheme.cardShow()) pairs").animation(.linear)
                        Stepper(onIncrement: {self.chosenTheme.changeNumCardShow(by: 1)}, onDecrement: {self.chosenTheme.changeNumCardShow(by: -1)}, label: {EmptyView()})
                    }
                }
           }
       }
        .onAppear{self.themeName = self.store.name(for: self.chosenTheme) ?? ""}
   }
    
    // MARK: - Drawing Constants
    
    var height: CGFloat {
        CGFloat((chosenTheme.emojis.count - 1) / 6) * 70 + 70
    }
    let fontSize: CGFloat = 40
}

