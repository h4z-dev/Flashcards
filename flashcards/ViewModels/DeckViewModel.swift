//
//  DeckViewModel.swift
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import SwiftUI

class DeckViewModel: ObservableObject {
    let db = Firestore.firestore()
    @AppStorage("userId") var userId: String = ""
    
    var deck: Deck = Deck()
    var loadingDeck: Bool = false
    var placeInDeck: Int = 0
    
    
    @Published var flipped: Bool = false
    @Published var editingDeck: Bool = true
    @Published var currentCard: Card = Card("empty_DECK", "empty_DECK", index: -2)
    
    init(deckHeader: DeckHeader) {
        self.deck = Deck(deckHeader: deckHeader)
        Task{
            loadCards()
            deck.sortDeck()
        }
    }
    
    func loadCards() {
        Task {
            guard !userId.isEmpty else {
                return
            }
            guard !loadingDeck else {
                return
            }
            loadingDeck.toggle()
            await deck = getCards(deckId: deck.deckHeader.name)
            getCurrentCard()
        }
    }
    
    func getCards(deckId: String) async -> Deck {
        var deck = Deck(deckHeader: deck.deckHeader)
        do {
            let deckDocument = try await db.collection("users").document(userId).collection("decks").document(deckId).getDocument()
            if let data = deckDocument.data() {
                var cards = [Card]()
                for (identification, cardData) in data {
                    if let cardData = cardData as? [String: Any],
                       let cardFront = cardData["front"] as? String,
                       let cardBack = cardData["back"] as? String,
                       let cardIndex = cardData["index"] as? Int,
                       let cardIdentification = UUID(uuidString: identification) {
                        let card = Card(cardFront, cardBack, index: cardIndex, cardIdentification)
                        cards.append(card)
                    }
                }
                // Sort cards by index before returning
                cards.sort(by: { $0.index < $1.index })
                deck.cards = cards
            }
        } catch {
            print("Error getting deck: \(error)")
        }
        return deck
    }
    
    
    func createNewCard(front: String, back: String) async {
        do {
            let cardIdString: String = UUID().uuidString
            let newCard = Card(front, back, index: deck.cards.count, UUID(uuidString: cardIdString)!)
            try await db.collection("users").document(userId).collection("decks").document(deck.deckHeader.name).setData([
                cardIdString: [
                    "index": deck.cards.count,
                    "front": front,
                    "back": back
                ]
            ], merge: true)
            
            // Have to run this on the main thread so SwiftUI goes OHHHH and updates the list rather than pretending nothing at all happened.
            DispatchQueue.main.async { [weak self] in
                self?.deck.cards.append(newCard)
                self?.objectWillChange.send()
            }
        } catch {
            print("Error creating new card: \(error)")
        }
    }
    
    func deleteCard(index: Int) {
        Task {
            await deleteCardFromDB(index)
            deck.cards.remove(at: index)
            var updatedCards = [Card]()
            for (newIndex, card) in deck.cards.enumerated() {
                let updatedCard = Card(card.front, card.back, index: newIndex, card.id)
                updatedCards.append(updatedCard)
            }
            deck.cards = updatedCards
            updateCardIndex()
        }
    }
    
    
    
    private func deleteCardFromDB(_ index: Int) async {
        do {
            let cardUUID = deck.cards[index].id.uuidString
            try await db.collection("users").document(userId).collection("decks").document(deck.deckHeader.name).updateData([
                cardUUID : FieldValue.delete()
            ])
        } catch {
            print(error)
        }
    }
    
    func cardTapped(index: Int) {
        withAnimation (.easeIn(duration: 10)) {
            deck.cards[index].isFlipped.toggle()
        }
    }
    
    func isEmpty() -> Bool {
        return deck.cards.isEmpty
    }
    
    func getCurrentCard() {
        if(isEmpty()) {
            return
        }
        DispatchQueue.main.async {
            self.currentCard = self.deck.cards[self.placeInDeck]
        }
    }
    
    func next() {
        if(!isEmpty() && deck.cards.count < 1) {
            return
        } else if (placeInDeck + 1 >= deck.cards.count ) {
            placeInDeck = 0
        } else {
            placeInDeck = placeInDeck + 1
        }
        getCurrentCard()
    }
    
    func previous() {
        if(!isEmpty() && deck.cards.count < 1) {
            return
        } else if (placeInDeck - 1 < 0) {
            placeInDeck = deck.cards.count - 1
        } else {
            placeInDeck = placeInDeck - 1
        }
        getCurrentCard()
    }
    
    func editDeck() {
        print("____SORT POINT______")
        for card in deck.cards{
            print("DEBUG: Card: \(card.front) index: \(card.index)")
        }
        print("\n")
        editingDeck.toggle()
        updateCardIndex()
        loadCards()
        getCurrentCard()
    }
    
    func updateCardIndex() {
        for card in deck.cards {
            let cardIdString : String = card.id.uuidString
            db.collection("users").document(userId).collection("decks").document(deck.deckHeader.name).setData([
                cardIdString : [
                    "index" : card.index,
                    "front" : card.front,
                    "back" : card.back
                ]
            ], merge: true)
        }
    }
    
    func moveCard(from source: IndexSet, to destination: Int) {
        guard let sourceIndex = source.first else { return }
        
        if (sourceIndex > deck.cards.count-1 || destination > deck.cards.count-1) {
            return
        }
        
        let movedCard = deck.cards.remove(at: sourceIndex)
        deck.cards.insert(movedCard, at: destination)
        
        for (index, _) in deck.cards.enumerated() {
            deck.cards[index].index = index
        }
        
        updateCardIndicesInFirestore()
    }
    
    func updateCardIndicesInFirestore() {
        for card in deck.cards {
            let cardIdString: String = card.id.uuidString
            db.collection("users").document(userId).collection("decks").document(deck.deckHeader.name).updateData([
                "\(cardIdString).index": card.index
            ]) { err in
                if let err = err {
                    print("Error updating index: \(err)")
                } else {
                    print("Index successfully updated")
                }
            }
        }
    }
    
    func updateCard(card: Card) {
        Task {
            await updateCardDB(card: card)
        }
    }
    
    private func updateCardDB(card: Card) async {
        do {
            let cardIdString: String = card.id.uuidString
            try await db.collection("users").document(userId).collection("decks").document(deck.deckHeader.name).updateData([
                cardIdString : FieldValue.delete()
            ])
        } catch {
            print(error)
        }
        deck.cards.remove(at: card.index)
        do {
            let cardIdString: String = card.id.uuidString
            let newCard = Card(card.front, card.back, index: card.index, UUID(uuidString: cardIdString)!)
            try await db.collection("users").document(userId).collection("decks").document(deck.deckHeader.name).setData([
                cardIdString: [
                    "index": card.index,
                    "front": card.front,
                    "back": card.back
                ]
            ], merge: true)
            
            // Have to run this on the main thread so SwiftUI goes OHHHH and updates the list rather than pretending nothing at all happened.
            DispatchQueue.main.async { [weak self] in
                self?.deck.cards.append(newCard)
                self?.deck.sortDeck()
                self?.objectWillChange.send()
            }
        } catch {
            print("Error creating new card: \(error)")
        }
    }
    
}
