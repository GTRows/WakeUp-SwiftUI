//
//  AwakeDetectionService.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 16.06.2023.
//

import Foundation
import Combine
import CoreMotion

class AwakeDetectionService: ObservableObject {
    private var motionManager: CMMotionManager
    @Published var isAwake: Bool = false
    private var sensorGyroscope: Bool
    private var sensorAccelerometer: Bool

    init(sensor: [Bool]) {
        sensorGyroscope = sensor[0]
        sensorAccelerometer = sensor[1]
        self.motionManager = CMMotionManager()
        startMonitoring()
    }

    func startMonitoring() {
        if sensorGyroscope {
            if motionManager.isGyroAvailable {
                print("Gyroscope started")
                motionManager.startGyroUpdates(to: .main) { (gyroData, error) in
                    guard let data = gyroData else { return }
                    self.isAwake = self.detectAwakeGyro(data: data)
                }
            } else{
                print("Gyroscope is not available")
            }
        }
        
        if sensorAccelerometer {
            if motionManager.isAccelerometerAvailable {
                print("Accelerometer started")
                motionManager.startAccelerometerUpdates(to: .main) { (accelerometerData, error) in
                    guard let data = accelerometerData else { return }
                    self.isAwake = self.detectAwakeAccelerometer(data: data)
                }
            } else {
                print("Accelerometer is not available")
            
            }
        }
    }

    // Dummy functions for detecting awake state based on sensor data
    // These should be replaced with your own logic
    private func detectAwakeGyro(data: CMGyroData) -> Bool {
        return abs(data.rotationRate.x) > 0.1 || abs(data.rotationRate.y) > 0.1 || abs(data.rotationRate.z) > 0.1
    }

    private func detectAwakeAccelerometer(data: CMAccelerometerData) -> Bool {
        return abs(data.acceleration.x) > 0.1 || abs(data.acceleration.y) > 0.1 || abs(data.acceleration.z) > 0.1
    }
}
