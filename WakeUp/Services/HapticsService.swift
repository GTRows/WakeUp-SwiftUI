//
//  HapticsService.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import SwiftUI
import CoreHaptics

class HapticsService {
    
    private var hapticEngine: CHHapticEngine?
    private var hapticPlayer: CHHapticAdvancedPatternPlayer?
    private var timer: Timer?

    private init() {
        prepareHaptics()
    }
    public static let shared = HapticsService()
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("Haptics not supported on this device.")
            AlertService.shared.showString(title: "Error", message: "Haptics not supported on this device.")
            return
        }
        
        do {
            let engine = try CHHapticEngine()
            self.hapticEngine = engine
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
            AlertService.shared.showString(title: "Error", message: "There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    public func startHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("Haptics not supported on this device.")
            AlertService.shared.showString(title: "Error", message: "Haptics not supported on this device.")
            return
        }

        do {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0) // Maximum intensity
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0) // Maximum sharpness
            // Creating a rhythmic pattern with 2 events: 4 seconds on, 4 seconds off
            let continuousEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 10) // 10 seconds duration
            
            let hapticPattern = try CHHapticPattern(events: [continuousEvent], parameters: [])

            hapticPlayer = try hapticEngine?.makeAdvancedPlayer(with: hapticPattern)

            try hapticEngine?.start()

            // To repeat the pattern indefinitely
            timer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { timer in
                do {
                    try self.hapticPlayer?.start(atTime: CHHapticTimeImmediate)
                } catch let error {
                    print("Haptic player start error: \(error)")
                    AlertService.shared.show(error: error)
                }
            }
        } catch let error {
            print("Haptic engine Error: \(error)")
            AlertService.shared.show(error: error)
        }
    }
    
    public func stopHaptics() {
        hapticEngine?.stop(completionHandler: nil)
        hapticPlayer = nil
        timer?.invalidate()
        timer = nil
    }
}
