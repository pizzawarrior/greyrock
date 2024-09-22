//
//  OverlayView.swift
//  Greyrock
//
//  Created by ian norstad on 9/22/24.
//

import SwiftUI

struct OverlayView: View {
    var selectedColor: Color

    var body: some View {
        Rectangle()
            .fill(selectedColor.opacity(0.5))
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
    }
}
