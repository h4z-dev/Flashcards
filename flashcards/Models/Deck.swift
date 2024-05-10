//
//  Flashcard.swift
//  flashcards
//
//  Created by Jacob Goodridge on 5/5/2024.
//

import Foundation

struct Deck {
    var contents: [[String]] = [[String]]()
    var name: String = ""
    
    mutating func add(front: String, back: String) {
        contents.append([front, back])
    }
    
    mutating func setName(name: String) {
        self.name = name
    }
    
    func toString() -> String {
        var out: String = ""
        for i in 0...contents.count - 1 {
            out += "Card \(i + 1): \(contents[i][0]), \(contents[i][1])\n"
        }
        return out
    }
    
    func toDict() -> [String : String] {
        var dict: [String : String] = [:]
        for card in contents {
            dict[card[0]] = card[1]
        }
        return dict
    }
    
    /// Returns number of flashcards in the deck
    /// Output:
    ///     Total number of flashcards as `Int`
    func count() -> Int {
        return contents.count
    }
}
