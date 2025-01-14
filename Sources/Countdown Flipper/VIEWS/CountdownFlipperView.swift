//
//  CountdownFlipperView.swift
//  Resources Uploader
//
//  Created by Kavinda Dilshan on 2024-11-09.
//

import SwiftUI

public struct CountdownFlipperView: View {
    // MARK: - PROPERTIES
    let flipperType: FlipFromTypes
    @State private var vm: CountdownFlipperViewModel
    @Binding var counter: Int
    
    // MARK: - INTIALIZER
    public init(flipperType: FlipFromTypes = .flipFromTop, counter: Binding<Int>, fontSize: CGFloat) {
    self.flipperType = flipperType
    _counter = counter
    _vm = State(initialValue: .init(fontSize: fontSize))
}
    
    // MARK: - BODY
    public var body: some View {
        VStack(spacing: 50) {
            ZStack {
                topSection
                bottomSection
            }
            .padding(vm.values.spaceBetweenFrames)
            .background { background }
            .environment(vm)
        }
        .onChange(of: counter) { onCounterChange($1) }
    }
}

// MARK: - PREVIEWS
#Preview("CountdownFlipperView") {
    @Previewable @State var counter: Int = 0
    VStack(spacing: 50) {
        CountdownFlipperView(counter: $counter, fontSize: 230)
        Button("Generate Random Number: \(counter)") {
            counter = .random(in: 0...9)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
    }
}

// MARK: - EXTENSIONS
extension CountdownFlipperView {
    // MARK: - topSection
    private var topSection: some View {
        TopLayerView(
            alignment: .top, topLayerCounter: vm.topSectionTopLayerCounter,
            angleX: vm.topSectionTopLayerAngleX,
            angleY: vm.topSectionTopLayerAngleY,
            angleZ: vm.topSectionTopLayerAngleZ
        )
        .background { BottomLayerView(alignment: .top, bottomLayerCounter: vm.topSectionBottomLayerCounter) }
        .zIndex(vm.currentflipperSection == .topSection ? 1 : 0)
    }
    
    // MARK: - bottomSection
    private var bottomSection: some View {
        TopLayerView(
            alignment: .bottom, topLayerCounter: vm.bottomSectionTopLayerCounter,
            angleX: vm.bottomSectionTopLayerAngleX,
            angleY: vm.bottomSectionTopLayerAngleY,
            angleZ: vm.bottomSectionTopLayerAngleZ
        )
        .background { BottomLayerView(alignment: .bottom, bottomLayerCounter: vm.bottomSectionBottomLayerCounter) }
        .zIndex(vm.currentflipperSection == .bottomSection ? 1 : 0)
    }
    
    // MARK: - background
    private var background: some View {
        RoundedRectangle(cornerRadius: vm.values.cornerRadiusLarge + vm.values.spaceBetweenFrames)
            .fill(Color.black)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - onCounterChange
    private func onCounterChange(_ newValue: Int) {
        Task {
            await vm.setCounter(newValue, flipperType: flipperType)
        }
    }
}
