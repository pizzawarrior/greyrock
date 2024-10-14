//
//  SocialUsageViewModel.swift
//  Greyrock
//
//  Created by ian norstad on 9/22/24.
//
// request auth from ScreenTimeManager/ UI logic/ Run timer/ save and load selected apps
//
import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings

class SocialUsageViewModel: ObservableObject {
    @Published var model = SocialUsageModel(timeLimit: 20, timeSpent: 0, selectedColor: .gray)
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
    
        // start monitoring the apps selected via the FamilyActivityPicker
       func startTrackingSelectedApps() {
           let selectedApps = activitySelection.applicationTokens

           // use ScreenTimeManager to start monitoring
           ScreenTimeManager.shared.startMonitoringApps(selectedApps: selectedApps) {
               // timer for testing purposes; 1 minute
               self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                   self.model.timeSpent += 1
                   if self.model.timeSpent >= self.model.timeLimit {
                       self.isTimeExceeded = true
                       self.stopTrackingApps()
                   }
               }
           }
       }

    func stopTrackingApps() {
        timer?.invalidate()
        timer = nil
    }

    func saveSelectedApps() {
        selectedAppIdentifiers = activitySelection.applicationTokens.compactMap { token in
            Application(token: token).bundleIdentifier // get bundle identifier from Application
        }
        UserDefaults.standard.set(selectedAppIdentifiers, forKey: "selectedApps")
    }

    func loadSelectedApps() {
        if let savedAppIdentifiers = UserDefaults.standard.array(forKey: "selectedApps") as? [String] {
            selectedAppIdentifiers = savedAppIdentifiers
        }
    }
}
