//
//  Flashcard.swift
//

import Foundation
import SwiftUI

struct Deck {
    var cards: [Card] = []
    var deckHeader: DeckHeader = DeckHeader()
    
    mutating func add(front: String, back: String) {
        cards.append(Card(front, back, index: cards.count))
    }
    
    mutating func add(front: String, back: String, index: Int) {
        if (index == -1) {
            add(front: front, back: back)
        } else {
            cards.append(Card(front, back, index: index))
        }
    }
    
    mutating func add(front: String, back: String, index: Int, id: UUID) {
        if (index == -1) {
            add(front: front, back: back)
        } else {
            cards.append(Card(front, back, index: index, id))
        }
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
    
    mutating func sortDeck() {
        cards = cards.sorted { $0.index < $1.index }
    }
}
