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
            guard !userId.isEmpty else{
                return
            }
            guard !loadingDeck else{
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
            // Attempt to fetch the whole deck first, so we can catch an error early if it occurs.
            let deckDocument = try await db.collection("users").document(userId).collection("decks").document(deckId).getDocument()
            if let data = deckDocument.data() {
                // Iterate over each key-value pair in the document data and reconstruct it to the Deck format
                for (identification, card) in data {
                    if identification != "DECK_HEADER",
                              let id = identification as? String,
                              let cardData = data[id] as? [String : Any],
                              let cardFront = cardData["front"] as? String,
                              let cardBack = cardData["back"] as? String,
                              let cardIndex = cardData["index"] as? Int,
                              let cardIdentification = UUID(uuidString: identification)
                    {
                        deck.add(front: cardFront, back: cardBack, index: cardIndex, id: cardIdentification)
                    }
                }
                loadingDeck.toggle()
                return deck
            } else {
                print("No data found in deck \(deckId)")
            }
        } catch {
            print("Error getting deck: \(error)")
        }
        loadingDeck.toggle()
        return deck
    }
    
    func createNewCard(front : String, back : String) async {
        do {
            let cardIdString : String = UUID().uuidString
            try await db.collection("users").document(userId).collection("decks").document(deck.deckHeader.name).setData([
                cardIdString : [
                    "index" : deck.cards.count,
                    "front" : front,
                    "back" : back
                ]
            ], merge: true)
        } catch {
            
        }
    }
    
    func deleteCard(index: Int){
        Task{
            await deleteCardFromDB(_: index)
        }
    }
    
    private func deleteCardFromDB(_ index: Int) async {
        do {
            try await db.collection("users").document(userId).collection("decks").document(deck.deckHeader.name).updateData([
                deck.cards[index].front : FieldValue.delete()
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
        if(isEmpty()){
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
}
