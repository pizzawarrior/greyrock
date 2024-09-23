//
//  InstagramUsageViewModel.swift
//  Greyrock
//
//  Created by ian norstad on 9/22/24.
//

//
// Handle authorization/ UI logic/ state management
//
import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings

class InstagramUsageViewModel: ObservableObject {
    @Published var model = InstagramUsageModel(timeLimit: 20, timeSpent: 0, selectedColor: .gray)
    @Published var isTimeExceeded = false
    @Published var selectedAppIdentifiers: [String] = []
    @Published var activitySelection = FamilyActivitySelection()

    private var timer: Timer?

    init() {
        loadSelectedApps()
        selectedAppIdentifiers = activitySelection.applicationTokens.compactMap { token in
            Application(token: token).bundleIdentifier // Get bundle identifier from Application
        }
    }

    // Request screen time authorization via ScreenTimeManager
        func requestAuthorization() {
            ScreenTimeManager.shared.requestScreenTimeAuthorization { authorized in
                if authorized {
                    print("Screen time authorization granted.")
                } else {
                    print("Screen time authorization failed.")
                }
            }
        }

    func stopTrackingInstagram() {
        timer?.invalidate()
        timer = nil
    }

    func saveSelectedApps() {
        selectedAppIdentifiers = activitySelection.applicationTokens.compactMap { token in
            Application(token: token).bundleIdentifier // Get bundle identifier from Application
        }
        UserDefaults.standard.set(selectedAppIdentifiers, forKey: "selectedApps")
    }

    func loadSelectedApps() {
        if let savedAppIdentifiers = UserDefaults.standard.array(forKey: "selectedApps") as? [String] {
            selectedAppIdentifiers = savedAppIdentifiers
        }
    }
}
