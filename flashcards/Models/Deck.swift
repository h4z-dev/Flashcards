//
//  Flashcard.swift
//

import Foundation
import SwiftUI

/// The structure that respresents a deck of flashcards.
struct Deck {
    var cards: [Card] = []                      /// We store each flashcard as an array of `Card`
    var deckHeader: DeckHeader = DeckHeader()   /// `deckHeader` gives us the title, image, and colour of the deck.
    
    /// Add a card to the deck
    /// Inputs:
    ///     - `front`, the text for the front side of the card, `String`
    ///     - `back`, the text for the back side of the card, `String`
    mutating func add(front: String, back: String) {
        cards.append(Card(front, back, index: cards.count))
    }
    
    /// Add a card to the deck
    /// Inputs:
    ///     - `front`, the text for the front side of the card, `String`
    ///     - `back`, the text for the back side of the card, `String`
    ///     - `index`, the location of the card in the deck, `Int`
    /// *If the index is invalid, we append to the back and don't set one*
    mutating func add(front: String, back: String, index: Int) {
        if (index == -1) {
            add(front: front, back: back)
        } else {
            cards.append(Card(front, back, index: index))
        }
    }
    
    /// Add a card to the deck
    /// Inputs:
    ///     - `front`, the text for the front side of the card, `String`
    ///     - `back`, the text for the back side of the card, `String`
    ///     - `index`, the location of the card in the deck, `Int`
    ///     - `id`, a unique value that refers to the card, `UUID`
    /// *If the index is invalid, we append to the back and don't set one*
    mutating func add(front: String, back: String, index: Int, id: UUID) {
        if (index == -1) {
            add(front: front, back: back)
        } else {
            cards.append(Card(front, back, index: index, id))
        }
    }
    
    /// Set the name of the deck
    /// Inputs:
    ///     - `name`, the name of the deck, `String`
    mutating func setName(name: String) {
        self.deckHeader.name = name
    }
    
    /// Represent cards of the deck as a string. Mostly useful for debugging and testing.
    /// Outputs:
    ///     - Each card with position and contents represented as a `String`
    func toString() -> String {
        var out: String = ""
        for i in 0...cards.count - 1 {
            out += "Card \(i + 1): \(cards[i].toString())\n"
        }
        return out
    }
    
    /// Represent the deck as a dictionary
    /// Outputs:
    ///     - Deck represented as a dictionary, keys being the front `String` and the values being the back `String`. Stored as `[String : String]`
    func toDict() -> [String : String] {
        var dict: [String : String] = [:]
        for card in cards {
            dict[card.front] = card.back
        }
        return dict
    }
    
    /// Returns number of flashcards in the deck
    /// Output:
    ///     Total number of flashcards as `Int`
    func count() -> Int {
        return cards.count
    }
    
    /// Sorts the deck by index
    mutating func sortDeck() {
        cards = cards.sorted { $0.index < $1.index }
    }
}
