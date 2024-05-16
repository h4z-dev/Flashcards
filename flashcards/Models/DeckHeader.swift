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
    
    /// Set a new name
    /// Inputs:
    ///     - `name`, name of the deck, `String`
    mutating func changeName(name: String) {
        self.name = name
    }
    
    /// Set a new symbol
    /// Inputs:
    ///     - `symbol`, symbol of the deck, `String`
    mutating func changeSymbol(symbol: String) {
        self.symbol = symbol
    }
    
    /// Set a new colour
    /// Inputs:
    ///     - `color`, colour of the deck, `Color`
    mutating func changeColor(color: Color) {
        self.color = color
    }
}
