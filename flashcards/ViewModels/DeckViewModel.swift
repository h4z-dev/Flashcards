//
//  DeckViewModel.swift
//  flashcards
//
//  Created by Jacob Goodridge on 7/5/2024.
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
    
    @Published var flipped: Bool = false
    @Published var placeInDeck: Int = 0
    @Published var editingDeck: Bool = true
    
    init(deckHeader: DeckHeader) {
        self.deck = Deck(deckHeader: deckHeader)
        Task{
            loadCards()
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
        }
    }
    
    func getCards(deckId: String) async -> Deck {
        var deck = Deck(deckHeader: deck.deckHeader)
        do {
            // Attempt to fetch the whole deck first, so we can catch an error early if it occurs.
            let deckDocument = try await db.collection("users").document(userId).collection("decks").document(deckId).getDocument()
            if let data = deckDocument.data() {
                // Iterate over each key-value pair in the document data and reconstruct it to the Deck format
                for (front, back) in data {
                    if let back = back as? String {
                        deck.add(front: front, back: back)
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
            try await db.collection("users").document(userId).collection("decks").document(deck.deckHeader.name).setData([
            front : back
        ], merge: true)
        } catch{
            print(error)
        }
    }
    
    func cardTapped(index: Int) {
        withAnimation (.easeIn(duration: 10)) {
            deck.cards[index].isFlipped.toggle()
        }
    }
    
    func isEmpty() -> Bool{
        return deck.cards.isEmpty
    }
    
    func currentCard() -> Card{
        guard !isEmpty() else {
            return Card("_____THIS_DECK_IS_Empty_____", "_____THIS_DECK_IS_Empty_____")
        }
        return deck.cards[placeInDeck]
    }
}
