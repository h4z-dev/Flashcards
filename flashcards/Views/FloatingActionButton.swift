//
//  FloatingActionButton.swift
//  flashcards
//
//  Created by Jacob Goodridge on 12/5/2024.
//

import Foundation
import SwiftUI

/// FloatingActionButton (FAB)
/// Inspired by https://developer.android.com/develop/ui/compose/components/fab
/// Adjustable variables:
/// - `iconName`, name of button icon `String`
/// - `backgroundColor`, colour of button which defaults to `accentColor`, `Color`
/// - `action`, some function to be performed when the button is tapped, `()`
struct FloatingActionButton: View {
    var iconName: String
    var backgroundColor: Color = .accentColor
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.title.weight(.semibold))
                .padding()
                .foregroundColor(.white)
                .background(backgroundColor)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
        }
    }
}

