//
//  ContentView.swift
//  Greyrock
//
//  Created by ian norstad on 9/22/24.
//
// handle state

import SwiftUI
import FamilyControls

struct ContentView: View {
    @StateObject var viewModel = SocialUsageViewModel()
    @State private var isPickerPresented = false
    
    var body: some View {
        VStack {
            Text("Set App Usage Time Limit (in minutes)")
                .font(.headline)
                .padding()
            
            Slider(value: $viewModel.model.timeLimit, in: 1...60, step: 1) {
                Text("Time Limit")
            }
            Text("\(Int(viewModel.model.timeLimit)) minutes")
                .padding()
            
            Button("Select Apps for Monitoring") {
                isPickerPresented = true
            }
            .familyActivityPicker(isPresented: $isPickerPresented, selection: $viewModel.activitySelection)
            .padding()
            
            Button("Start Tracking") {
                Task {
                    viewModel.requestAuthorization()
                    viewModel.startTrackingSelectedApps()
                }
            }
            .padding()
        }
        // save the selected apps when the selection changes
        .onChange(of: viewModel.activitySelection) {
            viewModel.saveSelectedApps()
        }
    }
}
