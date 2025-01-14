//
//  BottomLayerView.swift
//  Resources Uploader
//
//  Created by Kavinda Dilshan on 2024-11-10.
//

import SwiftUI

struct BottomLayerView: View {
    // MARK: - PROPERTIES
    let alignment: Alignment
    let bottomLayerCounter: Int
    
    @Environment(CountdownFlipperViewModel.self) private var vm
    var cornerRadiusSmall: CGFloat { vm.values.cornerRadiusSmall }
    var cornerRadiusLarge: CGFloat { vm.values.cornerRadiusLarge }
    
    // MARK: - INITIALIZER
    init(alignment: Alignment, bottomLayerCounter: Int) {
        self.alignment = alignment
        self.bottomLayerCounter = bottomLayerCounter
    }
    
    // MARK: - BODY
    var body: some View {
        Text("\(bottomLayerCounter)")
            .font(.system(size: vm.values.fontSize))
            .fontDesign(.rounded)
            .frame(width: vm.values.frameWidth, height: vm.values.frameHeight)
            .foregroundStyle(Color.black)
            .maskSection(alignment: alignment, height: vm.values.maskheight)
            .background(alignment: alignment) { background }
    }
}

// MARK: - PREVIEWS
#Preview("BottomLayerView - Top ALignment") {
    BottomLayerView(alignment: .top, bottomLayerCounter: 4)
        .environment(CountdownFlipperViewModel(fontSize: 230))
}

#Preview("BottomLayerView - Bottom ALignment") {
    BottomLayerView(alignment: .bottom, bottomLayerCounter: 4)
        .environment(CountdownFlipperViewModel(fontSize: 230))
}

// MARK: - EXTENSIONS
extension BottomLayerView {
    private var background: some View {
        UnevenRoundedRectangle(
            topLeadingRadius: alignment == .bottom ? cornerRadiusSmall : cornerRadiusLarge ,
            bottomLeadingRadius: alignment == .bottom ? cornerRadiusLarge : cornerRadiusSmall,
            bottomTrailingRadius: alignment == .bottom ? cornerRadiusLarge : cornerRadiusSmall,
            topTrailingRadius: alignment == .bottom ? cornerRadiusSmall : cornerRadiusLarge
        )
        .fill(.black)
        .shadow(color: vm.values.shadowColor, radius: vm.values.shadowRadius)
        .frame(height: vm.values.maskheight)
    }
}
