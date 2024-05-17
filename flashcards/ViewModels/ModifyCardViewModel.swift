//
//  ModifyCardViewModel.swift
//

import Foundation

/// ViewModel for modifying a flashcard
class ModifyCardViewModel : ObservableObject {
    @Published var card: Card
    @Published var cardFront: String
    @Published var cardBack: String
    
    /// Initialises the ViewModel with a given flashcard
    /// - Parameter card: Given flashcard to be modified by user, `Card`
    init(card: Card) {
        self.card = card
        self.cardFront = card.front
        self.cardBack = card.back
    }
    
    /// Updates the card with new text on front and back
    func updateCard() {
        card.setFrontBack(front: cardFront, back: cardBack)
    }
}
