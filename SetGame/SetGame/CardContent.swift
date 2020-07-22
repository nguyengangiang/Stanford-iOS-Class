//
//  CardContent.swift
//  SetGame
//
//  Created by Giang Nguyenn on 7/21/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

struct CardContent: Shape {
    var card: Card
    
    func path(in rect: CGRect) -> Path {
        let shape = card.symbol
        switch shape {
        case .diamond: return Diamond().path(in: rect)
        case .oval: return Capsule().path(in: rect)
        case .squiggle: return Rectangle().path(in: rect)
        }
    }
}
