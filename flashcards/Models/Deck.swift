//
//  Flashcard.swift
//  flashcards
//
//  Created by Jacob Goodridge on 5/5/2024.
//

import Foundation
import SwiftUI

struct Deck {
    var cards: [Card] = []
    var deckHeader: DeckHeader = DeckHeader()
    
    mutating func add(front: String, back: String) {
        cards.append(Card(front, back))
    }
    
    mutating func setName(name: String) {
        self.deckHeader.name = name
    }
    
    func toString() -> String {
        var out: String = ""
        for i in 0...cards.count - 1 {
            out += "Card \(i + 1): \(cards[i].toString())"
        }
        return out
    }
    
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
}
