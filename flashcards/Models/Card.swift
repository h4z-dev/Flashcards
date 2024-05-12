//
//  Card.swift
//  flashcards
//
//  Created by Jacob Goodridge on 10/5/2024.
//

import Foundation
import SwiftUI

struct Card : Hashable {
    var front: String
    var back: String
    var isFlipped: Bool = false
    var backgroundColor: Color = Color(.white)
    
    init(_ front: String, _ back: String) {
        self.front = front
        self.back = back
    }
    
    mutating func setFront(front: String) {
        self.front = front
    }
    
    mutating func setBack(back: String) {
        self.back = back
    }
    
    mutating func setFrontBack(front: String, back: String) {
        self.front = front
        self.back = back
    }
    
    func toString() -> String {
        return "\(self.front), \(self.back)"
    }
    
}
