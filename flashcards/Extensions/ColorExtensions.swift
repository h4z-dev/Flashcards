//
//  ColorExtensions.swift
//

import Foundation
import SwiftUI

// Gathered from https://gist.github.com/vibrazy/b105e3138105f604ab1ee4cfcdb67075
// https://medium.com/geekculture/using-appstorage-with-swiftui-colors-and-some-nskeyedarchiver-magic-a38038383c5e

/// These colour extensions allow us to save a SwiftUI colour as an `Int`, and revert back from the `Int` to a `Color`.
/// We use this to store colours in Firebase, which supports the `Int` data type.
class ColorExtensions {
    /// Returns some colour as an integer. Used when storing data in Firebase.
    /// - Parameter color: A `Color`
    /// - Returns: An integer representation of the colour, as `Int`
    func rawColorValue(color: Color) -> Int {
        let preprocessedColor = CIColor(color: UIColor(color))
        let red = Int(preprocessedColor.red * 255 + 0.5)
        let green = Int(preprocessedColor.green * 255 + 0.5)
        let blue = Int(preprocessedColor.blue * 255 + 0.5)
        return (red << 16) | (green << 8) | blue
    }
    
    /// Returns some encoded integer as a colour. Used when pulling colour information from Firebase.
    /// - Parameter input: An encoded colour, `Int`
    /// - Returns: The decoded colour, as `Color`
    func returnColorValueFromRaw(input: Int) -> Color {
        let red = Double((input & 0xFF0000) >> 16) / 0xFF
        let green = Double((input & 0x00FF00) >> 8) / 0xFF
        let blue = Double(input & 0x0000FF) / 0xFF
        return Color(red: red, green: green, blue: blue)
    }
}
