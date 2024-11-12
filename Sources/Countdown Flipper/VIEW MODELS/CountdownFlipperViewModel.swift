//
//  CountdownFlipperViewModel.swift
//  Resources Uploader
//
//  Created by Kavinda Dilshan on 2024-11-10.
//

import SwiftUI

@MainActor @Observable
final class CountdownFlipperViewModel {
    // MARK: - PROPERTIES
    let values: CountdownFlipperValues
    
    private(set) var counter: Int = 0
    var currentflipperSection: FlipperSectionTypes = .bottomSection
    private let duration: TimeInterval = 0.3
    @ObservationIgnored var durationNanoSeconds: UInt64 {
        UInt64(1_000_000_000 * duration)
    }
    
    // Layer Counter Related
    /// Top Section
    private(set) var topSectionTopLayerCounter: Int = 0
    private(set) var topSectionBottomLayerCounter: Int = 0
    /// Bottom Section
    private(set) var bottomSectionTopLayerCounter: Int = 0
    private(set) var bottomSectionBottomLayerCounter: Int = 0
    
    // Angle Related
    /// Top Section
    private(set) var topSectionTopLayerAngleX: CGFloat = 0
    private(set) var topSectionTopLayerAngleY: CGFloat = 0
    private(set) var topSectionTopLayerAngleZ: CGFloat = 0
    /// Bottom Section
    private(set) var bottomSectionTopLayerAngleX: CGFloat = 0
    private(set) var bottomSectionTopLayerAngleY: CGFloat = 0
    private(set) var bottomSectionTopLayerAngleZ: CGFloat = 0
    
    // Card Gradients Related
    let clearGradient: LinearGradient = .init(colors: [], startPoint: .top, endPoint: .bottom)
    var colorTop: LinearGradient = .init(colors: [], startPoint: .top, endPoint: .bottom)
    var colorBottom: LinearGradient = .init(colors: [], startPoint: .top, endPoint: .bottom)
    
    // MARK: - INITIALIZER
    init(fontSize: CGFloat) {
        self.values = .init(fontSize: fontSize)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - setCounter
    func setCounter(_ newValue: Int, flipperType: FlipFromTypes) async {
        guard newValue < 10 && newValue >= 0 else { return }
        counter = newValue
        await flipCounter(flipperType)
    }
    
    // MARK: - resetSectionAngles
    private func resetSectionAngles() {
        switch currentflipperSection {
        case .topSection:
            topSectionTopLayerAngleX = 0
            topSectionTopLayerAngleY = 0
            topSectionTopLayerAngleZ = 0
        case .bottomSection:
            bottomSectionTopLayerAngleX = 0
            bottomSectionTopLayerAngleY = 0
            bottomSectionTopLayerAngleZ = 0
        }
    }
    
    // MARK: - resetSectionPositions
    private func resetSectionPositions() async {
        topSectionTopLayerCounter = counter
        bottomSectionTopLayerCounter = counter
        resetSectionAngles()
    }
    
    // MARK: - changeColorOnCounterDecrement
    private func changeColorOnCounterDecrement() {
        colorTop = .init(
            colors: [.secondary.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottom
        )
        colorBottom = .init(
            colors: [.secondary.opacity(0.5), .white],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - changeColorOnCounterIncrement
    private func changeColorOnCounterIncrement() {
        colorTop = .init(
            colors: [.secondary.opacity(0.2)],
            startPoint: .top,
            endPoint: .bottom
        )
        colorBottom = .init(
            colors: [.secondary.opacity(0.5), .white],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - updateTopLayerCounter
    private func updateTopLayerCounter() {
        switch currentflipperSection {
        case .topSection:
            topSectionTopLayerCounter = counter
        case .bottomSection:
            bottomSectionTopLayerCounter = counter
        }
    }
    
    // MARK: - updateBottomLayerCounter
    private func updateBottomLayerCounter() {
        switch currentflipperSection {
        case .topSection:
            topSectionBottomLayerCounter = counter
        case .bottomSection:
            bottomSectionBottomLayerCounter = counter
        }
    }
    
    // MARK: - rotateFirstHalf
    private func rotateFirstHalf() {
        withAnimation(.easeIn(duration: duration)) {
            switch currentflipperSection {
            case .topSection:
                topSectionTopLayerAngleX = -90
                
                // Increase shadow like effect while rotating X Axis
                changeColorOnCounterDecrement()
                
            case .bottomSection:
                bottomSectionTopLayerAngleX = 90
                
                // Increase shadow like effect while rotating X Axis
                changeColorOnCounterIncrement()
            }
        }
    }
    
    // MARK: - clearColorOnFirstHalfRotation
    private func clearColorOnFirstHalfRotation() {
        switch currentflipperSection {
        case .topSection:
            colorTop = clearGradient
        case .bottomSection:
            colorBottom = clearGradient
        }
    }
    
    // MARK: - mirrorCardContent
    private func mirrorCardContent() {
        switch currentflipperSection {
        case .topSection:
            topSectionTopLayerAngleZ = 180
            topSectionTopLayerAngleY = 180
        case .bottomSection:
            bottomSectionTopLayerAngleZ = -180
            bottomSectionTopLayerAngleY = -180
            
        }
    }
    
    // MARK: - rotateSecondHalf
    private func rotateSecondHalf() {
        withAnimation(.easeOut(duration: duration)) {
            switch currentflipperSection {
            case .topSection:
                topSectionTopLayerAngleX += -90
            case .bottomSection:
                bottomSectionTopLayerAngleX += 90
            }
        }
    }
    
    // MARK: - clearColorOnAllTopLayerCards
    private func clearColorOnAllTopLayerCards() {
        colorTop = clearGradient
        colorBottom = clearGradient
    }
    
    // MARK: - flipSectionToplayer
    private func flipSectionToplayer() async {
        // Set new counter for the bottom layer before rotating +/- 90 degrees
        updateBottomLayerCounter()
        
        // Start the first +/- 90 degree rotation
        rotateFirstHalf()
        
        // Wait until `topSectionTopLayerAngleX` reaches +/-90 degrees
        try? await Task.sleep(nanoseconds: durationNanoSeconds)
        
        // Clear the color when the card is at +/- 90 degrees
        clearColorOnFirstHalfRotation()
        
        // Mirror the card content after +/- 90 degrees
        mirrorCardContent()
        
        // Set new counter for the top layer before rotating another +/- 90 degrees
        updateTopLayerCounter()
        
        // Rotate another +/- 90 degrees to get a full +/-180 degrees
        rotateSecondHalf()
        
        // Wait until `top/botomSectionTopLayerAngleX` reaches +/-180 degrees
        try? await Task.sleep(nanoseconds: durationNanoSeconds)
        
        // Clear the color when the cards are at +/-180 degrees
        clearColorOnAllTopLayerCards()
    }
    
    // MARK: - flipCounter
    private func flipCounter(_ type: FlipFromTypes) async {
        switch type {
        case .flipFromBottom:
            currentflipperSection = .bottomSection
        case .flipFromTop:
            currentflipperSection = .topSection
        }
        
        await flipSectionToplayer()
        await resetSectionPositions()
    }
}
