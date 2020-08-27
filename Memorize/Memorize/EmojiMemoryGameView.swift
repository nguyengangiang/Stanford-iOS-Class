//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Giang Nguyenn on 6/28/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        Group {
            Text(self.viewModel.getTheme().name)
            Text(self.viewModel.displayScore())
            Grid(self.viewModel.cards) {card in
                  CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.75)) {
                        self.viewModel.choose(card: card)
                    }
                  }
              .padding(5)
            }
            .foregroundColor(Color(self.viewModel.getTheme().color))
            .padding()
            
            Button( action: {
                withAnimation(.easeInOut) {
                    self.viewModel.newGame(theme: self.viewModel.getTheme())}
            }, label:  {Text("New Game") })
        }
    }
}


struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body : some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                         Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-card.bonusRemaining*360 - 90), clockwise: true)
                             .onAppear() {
                                 self.startBonusTimeAnimation()
                         }
                     } else {
                         Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-card.bonusRemaining*360 - 90), clockwise: true)
                     }
                }
                .padding(5).opacity(0.4)
 
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration:1).repeatForever(autoreverses: false) : .default)

            }
            .cardify(isFaceUp: card.isFaceUp)
                // .aspectRatio(2/3, contentMode: .fill)
            .transition(AnyTransition.scale)
        }
    }
    // MARK: - Drawing Constants
    private let fontScale: CGFloat = 0.7
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height)*fontScale
    }
}
