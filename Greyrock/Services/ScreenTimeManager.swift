//
//  ScreenTimeManager.swift
//  Greyrock
//
//  Created by ian norstad on 9/22/24.
//

import FamilyControls
import DeviceActivity
import SwiftUI
import ManagedSettings

class ScreenTimeManager {
    static let shared = ScreenTimeManager()

    func requestScreenTimeAuthorization(completion: @escaping (Bool) -> Void) {
        AuthorizationCenter.shared.requestAuthorization(for: .individual) { result in
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                print("Authorization failed: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

//    Why is this a dupe in InstagramUsageViewModel?
    func startMonitoringInstagram(timeLimit: Double, completion: @escaping () -> Void) {
        let instagramToken = ApplicationToken("com.burbn.instagram")

        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59)
        )

        let center = DeviceActivityCenter()
        center.startMonitoring(.daily(during: schedule, applications: [instagramToken]))
    }
}
