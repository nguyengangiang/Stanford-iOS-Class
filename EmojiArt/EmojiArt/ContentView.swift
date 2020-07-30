//
//  ContentView.swift
//  EmojiArt
//
//  Created by Giang Nguyenn on 7/29/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView()
    }
}
