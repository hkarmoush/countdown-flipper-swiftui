//
//  TopLayerView.swift
//  Resources Uploader
//
//  Created by Kavinda Dilshan on 2024-11-10.
//

import SwiftUI

struct TopLayerView: View {
    // MARK: - PROPERTIES
    let alignment: Alignment
    let topLayerCounter: Int
    let angleX: CGFloat
    let angleY: CGFloat
    let angleZ: CGFloat
    
    @Environment(CountdownFlipperViewModel.self) private var vm
    var cornerRadiusSmall: CGFloat { vm.values.cornerRadiusSmall }
    var cornerRadiusLarge: CGFloat { vm.values.cornerRadiusLarge }
    
    // MARK: - INITIALIZER
    init(alignment: Alignment, topLayerCounter: Int, angleX: CGFloat, angleY: CGFloat, angleZ: CGFloat) {
        self.alignment = alignment
        self.topLayerCounter = topLayerCounter
        self.angleX = angleX
        self.angleY = angleY
        self.angleZ = angleZ
    }
    
    // MARK: - BODY
    var body: some View {
        Text("\(topLayerCounter)")
            .rotation3DEffect(.degrees(angleY), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(.degrees(angleZ), axis: (x: 0, y: 0, z: 1))
            .font(.system(size: vm.values.fontSize))
            .fontDesign(.rounded)
            .frame(width: vm.values.frameWidth, height: vm.values.frameHeight)
            .foregroundStyle(Color.white)
            .maskSection(alignment: alignment, height: vm.values.maskheight)
            .background(alignment: alignment) { background }
            .rotation3DEffect(.degrees(angleX), axis: (x: 1, y: 0, z: 0))
    }
}

// MARK: - PREVIEWS
#Preview("TopLayerView - Top Alignment") {
    TopLayerView(alignment: .top, topLayerCounter: 5, angleX: 0, angleY: 0, angleZ: 0)
        .environment(CountdownFlipperViewModel(fontSize: 230))
}

#Preview("TopLayerView - Bottom Alignment") {
    TopLayerView(alignment: .bottom, topLayerCounter: 5, angleX: 0, angleY: 0, angleZ: 0)
        .environment(CountdownFlipperViewModel(fontSize: 230))
}

// MARK: - EXTENSIONS
extension TopLayerView {
    private var background: some View {
        UnevenRoundedRectangle(
            topLeadingRadius: alignment == .top ? cornerRadiusLarge : cornerRadiusSmall,
            bottomLeadingRadius: alignment == .top ? cornerRadiusSmall : cornerRadiusLarge,
            bottomTrailingRadius: alignment == .top ? cornerRadiusSmall : cornerRadiusLarge,
            topTrailingRadius: alignment == .top ? cornerRadiusLarge : cornerRadiusSmall
        )
        .fill(.black)
        .fill(alignment == .top ? vm.colorTop : vm.clearGradient)
        .fill(alignment == .bottom ? vm.colorBottom :vm.clearGradient)
        .shadow(color: vm.values.shadowColor, radius: vm.values.shadowRadius)
        .frame(height: vm.values.maskheight)
    }
}
