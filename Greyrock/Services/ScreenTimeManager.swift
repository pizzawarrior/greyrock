//
//  ScreenTimeManager.swift
//  Greyrock
//
//  Created by ian norstad on 9/22/24.
//
// Handle requesting auth/ 

import FamilyControls
import DeviceActivity
import SwiftUI
import ManagedSettings

class ScreenTimeManager {
    static let shared = ScreenTimeManager()

    // Request screen time authorization
    func requestScreenTimeAuthorization(completion: @escaping (Bool) -> Void) {
        Task {
            do {
                // request authorization
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                completion(true)  // auth granted
            } catch {
                print("Authorization failed: \(error.localizedDescription)")
                completion(false)  // auth failed
            }
        }
    }

    // Start monitoring selected apps (replaces direct Instagram reference)
    func startMonitoringApps(selectedApps: Set<ApplicationToken>, completion: @escaping () -> Void) {
        guard !selectedApps.isEmpty else {
            print("No apps selected for monitoring.")
            return
        }

        // Create a daily schedule
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        // Name the activity for monitoring
        let activityName = DeviceActivityName("com.greyrock.monitoring")

        // Start monitoring the selected apps
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(activityName, during: schedule)
            // Call completion when monitoring starts successfully
            completion()
        } catch {
            print("Failed to start monitoring: \(error.localizedDescription)")
            completion()
        }
    }
}

