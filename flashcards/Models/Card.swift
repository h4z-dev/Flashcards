//
//  Card.swift
//  flashcards
//
//  Created by Jacob Goodridge on 10/5/2024.
//

import Foundation
import SwiftUI

struct Card : Identifiable, Hashable {
    var id: UUID
    var index: Int
    var front: String
    var back: String
    var isFlipped: Bool = false
    var backgroundColor: Color = Color(.white)
    
    init(_ front: String, _ back: String, index: Int,_ id: UUID = UUID()) {
        self.front = front
        self.back = back
        self.index = index
        self.id = id
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
    
    mutating func setBackgroundColor(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }
    
    func toString() -> String {
        return "\(self.front), \(self.back)"
    }
    
}
