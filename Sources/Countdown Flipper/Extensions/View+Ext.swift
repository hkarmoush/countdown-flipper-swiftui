//
//  View+Ext.swift
//  Resources Uploader
//
//  Created by Kavinda Dilshan on 2024-11-11.
//

import SwiftUI

extension View {
    func maskSection(alignment: Alignment, height: CGFloat) -> some View {
        self
            .mask(alignment: alignment) {
                Rectangle()
                    .frame(height: height)
            }
    }
}
