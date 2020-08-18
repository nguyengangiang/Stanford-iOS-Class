//
//  Theme.swift
//  Memorize
//
//  Created by Giang Nguyenn on 7/8/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import Foundation
import SwiftUI

struct Theme: Codable {
    var emojis: [String]
    var numberOfCardsShow: Int
    var name: String
    var color: UIColor.RGB
     
    init(emojis: [String], numberOfCardsShow: Int, name: String, color: UIColor.RGB) {
        self.emojis = emojis
        self.numberOfCardsShow = numberOfCardsShow
        self.name = name
        self.color = color
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let newTheme = try? JSONDecoder().decode(Theme.self, from: json!) {
            self = newTheme
        } else {
            return nil
        }
    }

}


let themes = [halloween, animal, sport, scene, fruit, flag]

private let halloween = Theme(emojis:["👻", "👺", "💀", "🕷", "🎃"], numberOfCardsShow: 5, name: "Halloween", color: UIColor.RGB(red: 255, green: 165, blue: 0, alpha: 255))
private let animal = Theme(emojis: [ "🦚", "🐗", "🦕", "🦧", "🦔"], numberOfCardsShow: 5, name: "Animal", color: UIColor.RGB(red: 0, green: 0, blue: 200, alpha: 255))
private let sport = Theme(emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏸"], numberOfCardsShow: 6, name: "Sport", color: UIColor.RGB(red: 0, green: 200, blue: 0, alpha: 255))
private let scene = Theme(emojis: ["🏙", "🎇", "🌃", "🌌", "🌁", "🌉"], numberOfCardsShow: 6, name: "Scenery", color: UIColor.RGB(red: 127, green: 0, blue: 128, alpha: 255))
private let fruit = Theme(emojis:["🥝", "🍇", "🍉", "🥭"], numberOfCardsShow: 4, name: "Fruit", color: UIColor.RGB(red: 0, green: 100, blue: 50, alpha: 255))
private let flag = Theme(emojis:["🇫🇷", "🇷🇺", "🇹🇭", "🇱🇺", "🇳🇱"], numberOfCardsShow: 5, name: "Flag", color: UIColor.RGB(red: 150, green: 5, blue: 100, alpha: 255))

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
