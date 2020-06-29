//
//  ContentView.swift
//  Memorize
//
//  Created by Giang Nguyenn on 6/28/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        return HStack() {
            ForEach(0..<4) {index in
                cardView(isFaceUp: true)
                }
            }
        .padding()
        .foregroundColor(Color.orange)
        .font(Font.largeTitle)
        }
    }



struct cardView : View {
    var isFaceUp : Bool
    var body : some View {
        return ZStack {
            if (isFaceUp) {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3.0)
                Text("👻")
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
