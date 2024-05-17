//
//  DeckHeader.swift
//

import Foundation
import SwiftUI

/// Represents the title, colour, and icon for the header. Used in `Deck`
struct DeckHeader : Hashable {
    var name: String = ""                           /// Name of deck
    var symbol: String = "rectangle.on.rectangle"   /// Default icon for deck
    var color: Color = .white                       /// Default colour for deck
    
    /// Sets a new name for the deck
    /// - Parameter name: Name of the deck, `String`
    mutating func changeName(name: String) {
        self.name = name
    }
    
    /// Sets a new symbol for the deck
    /// - Parameter symbol: Symbol of the deck, `String`
    mutating func changeSymbol(symbol: String) {
        self.symbol = symbol
    }
    
    /// Sets a new colour for the deck
    /// - Parameter color: Colour of the deck, `Color`
    mutating func changeColor(color: Color) {
        self.color = color
    }
}
