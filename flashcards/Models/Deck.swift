//
//  Flashcard.swift
//

import Foundation
import SwiftUI

/// The structure that represents a deck of flashcards.
struct Deck {
    var cards: [Card] = []                      /// We store each flashcard as an array of `Card`
    var deckHeader: DeckHeader = DeckHeader()   /// `deckHeader` gives us the title, image, and colour of the deck.
    
    /// Adds a card to the deck
    /// - Parameters:
    ///   - front: The text for the front side of the card, `String`
    ///   - back: The text for the back side of the card, `String`
    mutating func add(front: String, back: String) {
        cards.append(Card(front, back, index: cards.count))
    }
    
    /// Adds a card to the deck
    /// - Parameters:
    ///   - front: The text for the front side of the card, `String`
    ///   - back: The text for the back side of the card, `String`
    ///   - index: The location of the card in the deck, `Int`
    /// *If the index is invalid, we append to the back and don't set one*
    mutating func add(front: String, back: String, index: Int) {
        if (index == -1) {
            add(front: front, back: back)
        } else {
            cards.append(Card(front, back, index: index))
        }
    }
    
    /// Adds a card to the deck
    /// - Parameters:
    ///   - front: The text for the front side of the card, `String`
    ///   - back: The text for the back side of the card, `String`
    ///   - index: The location of the card in the deck, `Int`
    ///   - id: A unique value that refers to the card, `UUID`
    /// *If the index is invalid, we append to the back and don't set one*
    mutating func add(front: String, back: String, index: Int, id: UUID) {
        if (index == -1) {
            add(front: front, back: back)
        } else {
            cards.append(Card(front, back, index: index, id))
        }
    }
    
    /// Sets the name of the deck
    /// - Parameter name: The name of the deck, `String`
    mutating func setName(name: String) {
        self.deckHeader.name = name
    }
    
    /// Represents cards of the deck as a string. Mostly useful for debugging and testing.
    /// - Returns: Each card with position and contents represented as a `String`
    func toString() -> String {
        var out: String = ""
        for i in 0...cards.count - 1 {
            out += "Card \(i + 1): \(cards[i].toString())"
        }
        return out
    }
    
    /// Represents the deck as a dictionary
    /// - Returns: Deck represented as a dictionary, keys being the front `String` and the values being the back `String`. Stored as `[String : String]`
    func toDict() -> [String : String] {
        var dict: [String : String] = [:]
        for card in cards {
            dict[card.front] = card.back
        }
        return dict
    }
    
    /// Returns the number of flashcards in the deck
    /// - Returns: Total number of flashcards as `Int`
    func count() -> Int {
        return cards.count
    }
    
    /// Sorts the deck by index
    mutating func sortDeck() {
        cards = cards.sorted { $0.index < $1.index }
    }
}
