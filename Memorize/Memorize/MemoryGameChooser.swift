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
                ForEach(self.store.themes) {chosenTheme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame.init(theme: chosenTheme))
                        .navigationBarTitle(self.store.name(for: chosenTheme) ?? ""))
                    {
                        Image(systemName: "pencil.circle.fill").opacity(self.editMode == .inactive ? 0 : 1)
                            .onTapGesture {
                                if (self.editMode == .active) {
                                    self.showPaletteEditor = true
                                }
                            }
                            .popover(isPresented: self.$showPaletteEditor) {
                                ThemeEditor(chosenTheme: self.$store.themes[self.store.themes.firstIndex(matching: chosenTheme)!], isShowing: self.$showPaletteEditor)
                                                .environmentObject(self.store)
                                                .frame(minWidth: 300, minHeight: 500)
                            }
                            .imageScale(.large).foregroundColor(Color(chosenTheme.color))
                        Text(self.store.name(for: chosenTheme) ?? "").bold().foregroundColor(Color(chosenTheme.color))
                        Text("\(chosenTheme.cardShow()) pairs of \(chosenTheme.emojiString())")
                    }

                }
                .onDelete { indexSet in
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
    @EnvironmentObject var store : ThemeStore
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
                        self.store.setName(self.chosenTheme, name: self.themeName)
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

