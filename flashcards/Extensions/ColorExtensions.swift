//
//  ColorExtensions.swift
//  flashcards
//
//  Created by Harris Vandenberg on 11/5/2024.
//

import Foundation
import SwiftUI

// gathered from https://gist.github.com/vibrazy/b105e3138105f604ab1ee4cfcdb67075
// https://medium.com/geekculture/using-appstorage-with-swiftui-colors-and-some-nskeyedarchiver-magic-a38038383c5e

class ColorExtensions {
    func rawColorValue(color: Color) -> Int {
        let preprocessedColor = CIColor(color: UIColor(color))
        let red = Int(preprocessedColor.red * 255 + 0.5)
        let green = Int(preprocessedColor.green * 255 + 0.5)
        let blue = Int(preprocessedColor.blue * 255 + 0.5)
        return (red << 16) | (green << 8) | blue
    }
    
    func returnColorValueFromRaw(input: Int) -> Color {
        let red =   Double((input & 0xFF0000) >> 16) / 0xFF
        let green = Double((input & 0x00FF00) >> 8) / 0xFF
        let blue =  Double(input & 0x0000FF) / 0xFF
        return Color(red: red, green: green, blue: blue)
    }
}
