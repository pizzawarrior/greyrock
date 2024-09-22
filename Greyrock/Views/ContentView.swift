//
//  ContentView.swift
//  Greyrock
//
//  Created by ian norstad on 9/22/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = InstagramUsageViewModel()

    var body: some View {
        ZStack {
            VStack {
                Text("Set Instagram Usage Time Limit (in minutes)")
                    .font(.headline)
                    .padding()

                Slider(value: $viewModel.model.timeLimit, in: 1...60, step: 1) {
                    Text("Time Limit")
                }
                Text("\(Int(viewModel.model.timeLimit)) minutes")
                    .padding()

                ColorPicker("Choose Filter Color", selection: $viewModel.model.selectedColor)
                    .padding()

                Button(action: {
                    viewModel.requestAuthorization()
                    viewModel.startTrackingInstagram()
                }) {
                    Text("Start Timer")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Text("Time spent on Instagram: \(Int(viewModel.model.timeSpent)) minutes")
                    .padding()

                if viewModel.isTimeExceeded {
                    Text("Time limit exceeded!")
                        .foregroundColor(.red)
                        .bold()
                }
            }

            // Overlay filter if time exceeded
            if viewModel.isTimeExceeded {
                OverlayView(selectedColor: viewModel.model.selectedColor)
            }
        }
    }
}

