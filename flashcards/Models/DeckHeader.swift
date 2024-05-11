//
//  DeckHeader.swift
//  flashcards
//
//  Created by Harris Vandenberg on 11/5/2024.
//

import Foundation
import SwiftUI

struct DeckHeader : Hashable {
    var name: String = ""
    var symbol: String = "rectangle.on.rectangle"
    var color: Color = .white
    
    mutating func changeName(name: String) {
        self.name = name
    }
    mutating func changeSymbol(symbol: String) {
        self.symbol = symbol
    }
    mutating func changeColor(color: Color) {
        self.color = color
    }
}
