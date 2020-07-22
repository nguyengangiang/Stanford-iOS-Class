//
//  Card.swift
//  SetGame
//
//  Created by Giang Nguyenn on 7/15/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import Foundation
import SwiftUI

struct Card: Identifiable {
    var id: Int
    var symbol: symbol
    var color: color
    var numberOfSymbol: numberOfSymbol
    var shading: shading
    var isMatched: Bool = false
    var isSelected: Bool = false
    
    enum symbol: Int, CaseIterable {
        case oval = 1
        case squiggle = 2
        case diamond = 3
        
        var value : Int {
            return self.rawValue
        }
    }
        
    enum color: Int, CaseIterable {
        case red = 1
        case blue = 2
        case green = 3
        
        var value : Int {
            return self.rawValue
        }
    }

    enum numberOfSymbol: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
        
        var value : Int {
            return self.rawValue
        }
    }
        
    enum shading: Int, CaseIterable {
        case solid = 1
        case striped = 2
        case empty = 3
        
        var value : Int {
            return self.rawValue
        }
    }
    
    private static func hash(symbol: Int, color: Int, numberOfSymbol: Int, shading: Int) -> Int {
        return shading + (symbol * 10) + (color * 100) + (numberOfSymbol * 1000)
    }
    
    init (symbol: symbol, color: color, numberOfSymbol: numberOfSymbol, shading: shading) {
        self.symbol = symbol
        self.color = color
        self.numberOfSymbol = numberOfSymbol
        self.shading = shading
        self.id = Card.hash(symbol: symbol.value, color: color.value, numberOfSymbol: numberOfSymbol.value, shading: shading.value)
    }
}
