//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Giang Nguyenn on 8/2/20.
//  Copyright © 2020 Giang Nguyen. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}
