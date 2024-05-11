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
    
    // TODO INIT DECK NAME FROM PREVIOUS VIEW
    var deckHeader: DeckHeader
    var deck: Deck = Deck()
    
    init(userId: String = "", deckHeader: DeckHeader) {
        self.userId = userId
        self.deckHeader = deckHeader
        loadCards()
    }
    
    func loadCards() {
        Task {
            await getCards(deckId: deckHeader.name)
        }
    }
    
    func getCards(deckId: String) async -> Deck {
        var deck = Deck()
        do {
            // Attempt to fetch the whole deck first, so we can catch an error early if it occurs.
            let deckDocument = try await db.collection("users").document(userId).collection("decks").document(deckId).getDocument()
            if let data = deckDocument.data() {
                deck.setName(name: deckId)
                // Iterate over each key-value pair in the document data and reconstruct it to the Deck format
                for (front, back) in data {
                    if let back = back as? String {
                        deck.add(front: front, back: back)
                    }
                }
                return deck
            } else {
                print("No data found in deck \(deckId)")
            }
        } catch {
            print("Error getting deck: \(error)")
        }
        return deck
    }
    
    func addButtonPressed() {
    
    }
    
    func cardTapped(index: Int) {
        
    }
}
