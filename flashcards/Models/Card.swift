//
//  Card.swift
//

import Foundation
import SwiftUI

/// A flashcard
struct Card : Identifiable, Hashable {
    var id: UUID                                /// Unique ID
    var index: Int                              /// Position in the `Deck`
    var front: String                           /// Contents on front of card
    var back: String                            /// Contents on back of card
    var isFlipped: Bool = false                 /// Flag storing whether the card is showing the reverse side, default false
    var backgroundColor: Color = Color(.white)  /// Colour of the card, defaults to white
    
    /// Initialiser, sets all the values
    /// - Parameters:
    ///   - front: Contents on front of card, `String`
    ///   - back: Contents on back of card, `String`
    ///   - index: Position in the deck, `Int`
    ///   - id: Unique ID of the card, `UUID`
    /// *front, back, and id do not have to be specified when calling Card due to the underscore in front of these variables (_)
    init(_ front: String, _ back: String, index: Int, _ id: UUID = UUID()) {
        self.front = front
        self.back = back
        self.index = index
        self.id = id
    }
    
    /// Sets the value on the front of the card
    /// - Parameter front: Contents on front, `String`
    mutating func setFront(front: String) {
        self.front = front
    }
    
    /// Sets the value on the back of the card
    /// - Parameter back: Contents on back, `String`
    mutating func setBack(back: String) {
        self.back = back
    }
    
    /// Sets the value on the front and the back of the card
    /// - Parameters:
    ///   - front: Contents on front, `String`
    ///   - back: Contents on back, `String`
    mutating func setFrontBack(front: String, back: String) {
        self.front = front
        self.back = back
    }
    
    /// Sets the background colour of the card
    /// - Parameter backgroundColor: The new background colour, `Color`
    mutating func setBackgroundColor(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }
    
    /// Returns a string representation of the card
    /// - Returns: Card represented as `String`
    func toString() -> String {
        return "\(self.front), \(self.back)"
    }
}
