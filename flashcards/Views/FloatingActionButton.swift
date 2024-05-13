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
    var foregroundColor: Color = .white

    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.title.weight(.semibold))
                .padding()
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 1.5, x: 0, y: 1)
        }
    }
}

/// Similar to FloatingActionButton but supports nsavigation between views.
/// Changed variables:
///  -  `destination`, the view to navigate to. `Destination` which is a generic `View`
struct FloatingActionNavigationLink<Destination: View>: View {
    var iconName: String
    var backgroundColor: Color = .accentColor
    var destination: Destination
    var foregroundColor: Color = .white

    var body: some View {
        NavigationLink(destination: destination) {
            Image(systemName: iconName)
                .font(.title.weight(.semibold))
                .padding()
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 1.5, x: 0, y: 1)
        }
    }
}

#Preview {
    FloatingActionButton(iconName: "plus") {}
}
