//
//  DeckViewModel.swift
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import SwiftUI


/// Responisble for storing the data and managing communications to the server
class DeckViewModel: ObservableObject {
    
    ///db variables
    let db = Firestore.firestore()
    @AppStorage("userId") var userId: String = ""
    
    ///local variables
    var deck: Deck = Deck()
    var loadingDeck: Bool = false
    var placeInDeck: Int = 0
    
    ///published variables
    @Published var flipped: Bool = false
    @Published var editingDeck: Bool = true
    @Published var currentCard: Card = Card("empty_DECK", "empty_DECK", index: -2)
    
    /// Initialises the deckview and sets up which deck it is showing, loads cards and then sorts them into the correct index
    /// - Parameter deckHeader: the header for the deck that
    init(deckHeader: DeckHeader) {
        self.deck = Deck(deckHeader: deckHeader)
        Task{
            loadCards()
            deck.sortDeck()
        }
    }
    
    /// initialises the loading of cards, checks for errors and manages the asynchronous tasks
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
    
    /// gets cards from FireStore, parses the data back into the card and
    /// - Parameter deckId: The String of the ID for the current deck that is being used
    /// - Returns: Returns the deck of cards (ensures we update on the main thread)
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
    
    /// Creates a new card and updates the DB. takes in front and back data and generates UUID and index adding it to the back of the queue
    /// - Parameters:
    ///   - front: Front of card data as a String
    ///   - back: Back of card data as a String
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
    
    /// Deletes a card by removing it form the deck and then calls the DB to delete it from the internet
    /// - Parameter index: the index of the card that should be deleted
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
    
    /// Deletes a card from the database given the index of the card
    /// - Parameter index: the index of the card to be deleted from the database
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
    
    /// Card tapped keeps track of which card was just tapped and if it has been flipped or not and toggles it with animation
    /// - Parameter index: The index of the card that was just tapped
    func cardTapped(index: Int) {
        withAnimation (.easeIn) {
            deck.cards[index].isFlipped.toggle()
        }
    }
    
    /// Returns the status of if the deck of cards
    /// - Returns: Bool of true if the deck isEmpty, false for any other number of cards within the array
    func isEmpty() -> Bool {
        return deck.cards.isEmpty
    }
    
    /// returns the current card at the top of the deck to be displayed
    func getCurrentCard() {
        if ( placeInDeck > deck.cards.count - 1) {
            placeInDeck = deck.cards.count - 1
        }
        
        if(isEmpty()) {
            return
        }
        DispatchQueue.main.async {
            self.currentCard = self.deck.cards[self.placeInDeck]
        }
    }
    
    /// Swaps over to the next card within the deck and then updates the current card
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
    
    /// Swaps over to the previous card within the deck and then updates the current card
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
    
    /// Edit deck swaps between the editing view and using going through the deck of cards
    func editDeck() {
        editingDeck.toggle()
        updateCardIndex()
        loadCards()
        getCurrentCard()
    }
    
    /// updates the indexes for all of the cards within the deck. Looping through the deck and then modifying the 
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
    
    /// Moves a card between positions given it's original position and it's destination position
    /// - Parameters:
    ///   - source: Original position of the card as it's index
    ///   - destination: destination to move the card to as it's index
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
    
    /// Brings in all cards and indexes them from within the DB, used after reordering cards
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
    
    /// Manages the Asyncronous management of of updating a card from within the deck
    /// - Parameter card: Card that will be modified after updating
    func updateCard(card: Card) {
        Task {
            await updateCardDB(card: card)
        }
    }
    
    /// Update card form DB, deletes the current card before recreating it from scratch
    /// - Parameter card: Takes in the modified card to be updated by the database
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
