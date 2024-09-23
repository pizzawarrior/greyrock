//
//  InstagramUsageViewModel.swift
//  Greyrock
//
//  Created by ian norstad on 9/22/24.
//
import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings

class InstagramUsageViewModel: ObservableObject {
    @Published var model = InstagramUsageModel(timeLimit: 20, timeSpent: 0, selectedColor: .gray)
    @Published var isTimeExceeded = false
    @Published var selectedAppIdentifiers: [String] = []
    @Published var selectedApps: Set<ApplicationToken> = []

    private var timer: Timer?

    init() {
        loadSelectedApps()
        selectedApps = Set(selectedAppIdentifiers.compactMap { ApplicationToken(bundleIdentifier: $0) }) // Ensure correct initialization
    }

    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            print("Authorization granted.")
        } catch {
            print("Authorization failed: \(error.localizedDescription)")
        }
    }

    func startTrackingInstagram() {
        guard !selectedAppIdentifiers.isEmpty else {
            print("No apps selected for monitoring.")
            return
        }

        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        let activityName = DeviceActivityName("com.greyrock.instagramTracking")

        let center = DeviceActivityCenter()
        try! center.startMonitoring(activityName, during: schedule)

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.model.timeSpent += 1
            if self.model.timeSpent >= self.model.timeLimit {
                self.isTimeExceeded = true
                self.stopTrackingInstagram()
            }
        }

        saveSelectedApps()
    }

    func stopTrackingInstagram() {
        timer?.invalidate()
        timer = nil
    }

    func saveSelectedApps() {
        UserDefaults.standard.set(selectedAppIdentifiers, forKey: "selectedApps")
    }

    func loadSelectedApps() {
        if let savedAppIdentifiers = UserDefaults.standard.array(forKey: "selectedApps") as? [String] {
            selectedAppIdentifiers = savedAppIdentifiers
        }
    }
}
