//
//  TimeView.swift
//  CountdownFlipper
//
//  Created by Kavinda Dilshan on 2024-11-11.
//

import SwiftUI

public struct TimeView: View {
    // MARK: - PROPERTIES
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentTime: TimeModel = .defaultValue
    @State private var timer: Timer?
    
    // MARK: - INITIALIZER
    public init() { }
    
    // MARK: - BODY
    public var body: some View {
        ViewThatFits {
            timeView(fontSize: 85, colonsSize: 10)
            timeView(fontSize: 40, colonsSize: 5)
        }
    }
}

// MARK: - PREVIEWS
#Preview("TimeView") {
    TimeView()
}

// MARK: - EXTENSIONS
extension TimeView {
    // MARK: - colons
    private func colons(colonsSize: CGFloat) -> some View {
        VStack {
            ForEach(1...2, id: \.self) { _ in
                Circle()
                    .fill(.secondary)
                    .frame(width: colonsSize, height: colonsSize)
            }
        }
    }
    
    // MARK: - timeView
    private func timeView(fontSize: CGFloat, colonsSize:  CGFloat) -> some View {
        HStack {
            HStack(spacing: 5) {
                CountdownFlipperView(counter: $currentTime.h1, fontSize: fontSize)
                CountdownFlipperView(counter: $currentTime.h2, fontSize: fontSize)
            }
            
            colons(colonsSize: colonsSize)
            
            HStack(spacing: 5) {
                CountdownFlipperView(counter: $currentTime.m1, fontSize: fontSize)
                CountdownFlipperView(counter: $currentTime.m2, fontSize: fontSize)
            }
            
            colons(colonsSize: colonsSize)
            
            HStack(spacing: 5) {
                CountdownFlipperView(counter: $currentTime.s1, fontSize: fontSize)
                CountdownFlipperView(counter: $currentTime.s2, fontSize: fontSize)
            }
        }
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - timeToTimeModel
    private func timeToTimeModel(date: Date) -> TimeModel? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        guard let hour = components.hour,
              let minute = components.minute,
              let second = components.second else { return nil }
        
        let hour12 = hour % 12 == 0 ? 12 : hour % 12 // Convert to 12-hour format
        
        let h1 = hour12 / 10
        let h2 = hour12 % 10
        let m1 = minute / 10
        let m2 = minute % 10
        let s1 = second / 10
        let s2 = second % 10
        
        return TimeModel(h1: h1, h2: h2, m1: m1, m2: m2, s1: s1, s2: s2)
    }
    
    
    // MARK: - startTimer
    private func startTimer() {
#if DEBUG
        print("Timer Started!")
#endif
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                let now = Date().addingTimeInterval(0.6) // flip duration is 0.3 by default for +/- 90 degrees, so to rotate +/-180 degrees it takes 0.6 seconds.
                guard let item: TimeModel = timeToTimeModel(date: now) else { return }
                currentTime = item
            }
        }
    }
    
    // MARK: - stopTimer
    private func stopTimer() {
#if DEBUG
        print("Timer Invalidated!")
#endif
        timer?.invalidate()
        timer = nil
        currentTime = .defaultValue
    }
}

// MARK: - MODELS
private struct TimeModel {
    // Hours
    var h1: Int
    var h2: Int
    // Minutes
    var m1: Int
    var m2: Int
    // Seconds
    var s1: Int
    var s2: Int
    
    static let defaultValue: Self = .init(h1: 0, h2: 0, m1: 0, m2: 0, s1: 0, s2: 0)
}
