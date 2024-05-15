//
//  ModifyCardViewModel.swift
//


import Foundation

class ModifyCardViewModel : ObservableObject {
    @Published var card: Card
    @Published var cardFront: String
    @Published var cardBack: String
    
    init(card: Card) {
        self.card = card
        self.cardFront = card.front
        self.cardBack = card.back
    }
    
    func updateCard(){
        card.setFrontBack(front: cardFront, back: cardBack)
    }
}
