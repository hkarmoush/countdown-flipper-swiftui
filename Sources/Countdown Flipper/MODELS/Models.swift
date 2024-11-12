//
//  Models.swift
//  Resources Uploader
//
//  Created by Kavinda Dilshan on 2024-11-10.
//

import Foundation
import SwiftUICore

enum FlipperSectionTypes {
    case topSection, bottomSection
}

public enum FlipFromTypes {
    case flipFromBottom, flipFromTop
}

struct CountdownFlipperValues {
    // MARK: - PROPERTIES
    let fontSize: CGFloat
    
    private var ratio: CGFloat { fontSize/200 }
    var spacingInBetween: CGFloat { ratio * 3 }
    var frameHeight: CGFloat { ratio * 340 }
    var frameWidth: CGFloat { ratio * 250 }
    var maskheight: CGFloat { frameHeight/2 - spacingInBetween }
    let shadowColor: Color = Color(uiColor: .systemGray5)
    let shadowRadius: CGFloat = 2
    var cornerRadiusSmall: CGFloat { ratio * 3 }
    var cornerRadiusLarge: CGFloat { ratio * 15 }
    var spaceBetweenFrames: CGFloat { ratio * 20 }
    
    // MARK: - INITIALIZER
    init(fontSize: CGFloat) {
        self.fontSize = fontSize
    }
}
