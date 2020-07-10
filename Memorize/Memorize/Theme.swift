//
//  Theme.swift
//  Memorize
//
//  Created by Giang Nguyenn on 7/8/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import Foundation
import SwiftUI

struct Theme {
    var emojis: [String]
    var numberOfCardsShow: Int?
    var name: String
    var color: Color
}

let themes = [halloween, animal, sport, scene, fruit, flag]
private let halloween = Theme(emojis: ["👻", "👺", "💀", "🕷", "🎃"], numberOfCardsShow: 5, name: "Halloween", color: Color.orange)
private let animal = Theme(emojis: ["🐫", "🐨", "🐼", "🐧", "🦚", "🐗", "🦕", "🐶", "🦊", "🦁", "🦧", "🦔"], numberOfCardsShow: Int.random(in: 2...6), name: "Animal", color: Color.blue)
private let sport = Theme(emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏸", "🏐", "🥋", "🏹"], numberOfCardsShow: Int.random(in: 2...6), name: "Sport", color: Color.red)
private let scene = Theme(emojis: ["🏙", "🎇", "🌃", "🌌", "🌁", "🌉", "🗾", "🎑", "🏞", "🌅", "🌄", "🌠", "🌆"], numberOfCardsShow: 4, name: "Scenery", color: Color.purple)
private let fruit = Theme(emojis:["🍓", "🍑", "🥥", "🍒", "🍈", "🥝", "🍇", "🍉", "🥭"], numberOfCardsShow: 4, name: "Fruit", color: Color.green)
private let flag = Theme(emojis: ["🇫🇷", "🇷🇺", "🇹🇭", "🇱🇺", "🇳🇱"], numberOfCardsShow: 5, name: "Flag", color: Color.pink)
