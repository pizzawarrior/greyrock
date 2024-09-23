//
//  ContentView.swift
//  Greyrock
//
//  Created by ian norstad on 9/22/24.
//

import SwiftUI
import FamilyControls

struct ContentView: View {
    @StateObject var viewModel = InstagramUsageViewModel()
    @State private var isPickerPresented = false
    
    var body: some View {
        VStack {
            Text("Set Instagram Usage Time Limit (in minutes)")
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
                    await viewModel.requestAuthorization()
                    viewModel.startTrackingSelectedApps()
                }
            }
            .padding()
        }
        .onChange(of: viewModel.activitySelection) { newSelection in
            // Save the selected apps when the selection changes
            viewModel.saveSelectedApps()
        }
    }
}

