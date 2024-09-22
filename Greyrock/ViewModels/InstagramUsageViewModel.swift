//
//  InstagramUsageViewModel.swift
//  Greyrock
//
//  Created by ian norstad on 9/22/24.
//
import SwiftUI
import FamilyControls
import DeviceActivity

class InstagramUsageViewModel: ObservableObject {
    @Published var model = InstagramUsageModel(timeLimit: 20, timeSpent: 0, selectedColor: .gray)
    @Published var isTimeExceeded = false

    private var timer: Timer?

    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            print("Authorization granted.")
        } catch {
            print("Authorization failed: \(error.localizedDescription)")
        }
    }

    // Start tracking Instagram usage
    func startTrackingInstagram() {
        // Create an ApplicationToken for Instagram (using its bundle identifier)
        let instagramToken = ApplicationToken("com.burbn.instagram")

        // Define a daily monitoring schedule
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59)
        )

        // Start monitoring Instagram usage with the schedule
        let center = DeviceActivityCenter()
        center.startMonitoring(
            .daily(during: schedule, applications: [instagramToken])
        )

        // Start timer to simulate time spent on Instagram (for testing purposes)
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.model.timeSpent += 1
            if self.model.timeSpent >= self.model.timeLimit {
                self.isTimeExceeded = true
                self.stopTrackingInstagram()
            }
        }
    }

    // Stop tracking Instagram usage
    func stopTrackingInstagram() {
        timer?.invalidate()
        timer = nil
    }
}


