//
//  Theme.swift
//  Memorize
//
//  Created by Giang Nguyenn on 7/8/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import Foundation
import SwiftUI

struct Theme: Codable, Hashable, Identifiable {
    var emojis: [String]
    var numberOfCardsShow: Int
    var name: String
    var color: UIColor.RGB
     
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(emojis: [String], name: String, color: UIColor.RGB, id: UUID? = nil)
    {
        self.emojis = emojis
        self.numberOfCardsShow = emojis.count
        self.name = name
        self.color = color
        self.id = id ?? UUID()
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
    
    mutating func setName(name: String) {
        self.name = name
    }
    
    mutating func addEmoji(emoji: String) {
        if (self.numberOfCardsShow < emojis.count + 1) {
            self.emojis.append(emoji)
        }
    }
    
    mutating func removeEmoji(emoji: String) {
        if (self.emojis.contains(emoji) && emojis.count > 2 && emojis.count - 1 > numberOfCardsShow) {
            self.emojis.remove(at: self.emojis.firstIndex(of: emoji)!)
        }
    }
    
    mutating func changeNumCardShow(by amount: Int) {
        if (self.numberOfCardsShow + amount > 1 && self.numberOfCardsShow + amount <= emojis.count) {
            self.numberOfCardsShow += amount
        }
    }
    
    func cardShow() -> Int {
        return numberOfCardsShow
    }

    func emojiString() -> String {
        return emojis.joined()
    }
}


extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
