//
//  Array+Only.swift
//  Memorize
//
//  Created by Giang Nguyenn on 7/3/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
