//
//  HomeViewModel.swift
//  flashcards
//
//  Created by Jacob Goodridge on 5/5/2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import SwiftUI

class HomeViewModel: ObservableObject {
    let db = Firestore.firestore()
    var deck = Deck()
    @Published var deckHeaders: [DeckHeader] = []
    @Published var isAddingDeck: Bool = false
    @Published var selectedDeck: DeckHeader?
    @Published var selectedDeckId: String?
    
    
    @AppStorage("userId") var userId: String = ""
    
    init() {
        //        self.authModel = authModel
        //        flashcard.add(front: "test1", back: "test2")
        //        flashcard.add(front: "aaa", back: "bbb")
        //        flashcard.add(front: "111", back: "222")
        //        print(flashcard.toString())
        Task {
            await fetchDeckNames()
            await getCards(deckId: "0")
        }
    }
    
    func addCards() async {
        do {
            try await db.collection("users").document(userId).collection("decks").document("0").setData(deck.toDict())
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    func getCards(deckId: String) async {
        do {
            // Attempt to fetch the whole deck first, so we can catch an error early if it occurs.
            let deckDocument = try await db.collection("users").document(userId).collection("decks").document(deckId).getDocument()
            if let data = deckDocument.data() {
                var deck = Deck()
                deck.setName(name: deckId)
                // Iterate over each key-value pair in the document data and reconstruct it to the Deck format
                for (front, back) in data {
                    if let back = back as? String {
                        deck.add(front: front, back: back)
                    }
                }
                print(deck.toString())
            } else {
                print("No data found in deck \(deckId)")
            }
        } catch {
            print("Error getting deck: \(error)")
        }
    }
    
    func fetchDeckNames() async {
        var deckHeaderStack: [DeckHeader] = []
        do {
            let decksSnapshot = try await db.collection("users").document(userId).collection("decks").getDocuments()
            var names: [String] = []
            for deckDocument in decksSnapshot.documents {
                names.append(deckDocument.documentID)
            }
            
            for (index, name) in names.enumerated() {
                let data = decksSnapshot.documents[index].data()
                if let deckHeaderData = data["DECK_HEADER"] as? [String: Any],
                   let deckName = deckHeaderData["deckName"] as? String,
                   let deckLogo = deckHeaderData["deckLogo"] as? String,
                   let deckColorInt = deckHeaderData["deckColor"] as? Int {
                    deckHeaderStack.append(DeckHeader(name: deckName, symbol: deckLogo, color: Color(ColorExtensions().returnColorValueFromRaw(input: deckColorInt))))
                } else {
                    deckHeaderStack.append(DeckHeader(name: name))
                    print("OLD DECK DETECTED! \(name)")
                }
            }
        } catch {
            print("Error retrieving deck names: \(error)")
        }
        DispatchQueue.main.async{
            self.deckHeaders = deckHeaderStack
        }
    }
    
    func createNewDeck(deckName: String, deckColor: Color, deckLogo: String) async throws {
        var deckHeaders = self.deckHeaders
        do {
            let decksSnapshot = try await db.collection("users").document(userId).collection("decks").getDocuments()
            var names: [String] = []
            for deckDocument in decksSnapshot.documents {
                names.append(deckDocument.documentID)
            }
            for name in names {
                if(name == deckName) {
                    throw LoginErrors.deckALreadyExists
                }
            }
        } catch {
            print("Error retrieving deck names: \(error)")
            return
        }
        do {
            //            let colorComponents = UIColor(deckColor).cgColor.components {
            try await db.collection("users").document(userId).collection("decks").document(deckName).setData([
                "DECK_HEADER" : [
                    "deckName" : deckName,
                    "deckLogo" : deckLogo,
                    "deckColor" : ColorExtensions().rawColorValue(color: deckColor)
                ]
            ], merge: true)
        }
        catch {
            print("ERROR CREATING DECK: \(error)")
            return
        }
        deckHeaders.append(DeckHeader(name: deckName, symbol: deckLogo, color: deckColor))
        DispatchQueue.main.async{
            self.deckHeaders = deckHeaders
        }
    }
    
    //    func fireStoreExample() async {
    //        // Add a new document with a generated ID
    //        do {
    //            let ref = try await db.collection("users").addDocument(data: [
    //                "first": "Ada",
    //                "last": "Lovelace",
    //                "born": 1815
    //            ])
    //            print("Document added with ID: \(ref.documentID)")
    //        } catch {
    //            print("Error adding document: \(error)")
    //        }
    //
    //        // Add a second document with a generated ID.
    //        do {
    //            let ref = try await db.collection("users").addDocument(data: [
    //                "first": "Alan",
    //                "middle": "Mathison",
    //                "last": "Turing",
    //                "born": 1912
    //            ])
    //            print("Document added with ID: \(ref.documentID)")
    //        } catch {
    //            print("Error adding document: \(error)")
    //        }
    //
    //        do {
    //            let snapshot = try await db.collection("users").getDocuments()
    //            for document in snapshot.documents {
    //                print("\(document.documentID) => \(document.data())")
    //            }
    //        } catch {
    //            print("Error getting documents: \(error)")
    //        }
    //
    //    }
    
    func addButtonPressed() {
        isAddingDeck.toggle()
    }
    
    /// Deletes specified Deck and updates the content visible to the user.
    /// - Inputs:
    ///     `deckName`, name of the deck.    `String`
    func deleteDeck(_ deckName: String) async {
        var deckHeaders = self.deckHeaders
        do {
            // Delete the deck from Firestore
            try await db.collection("users").document(userId).collection("decks").document(deckName).delete()
            // Locally remove all decks that match that of the deleted one
            deckHeaders.removeAll {
                $0.name == deckName
            }
        } catch {
            print("Error deleting deck: \(error)")
        }
        DispatchQueue.main.async{
            self.deckHeaders = deckHeaders
        }
    }
    
    ///
    /// - Inputs:
    ///     `deckName`, name of the deck.    `String`
    //    func confirmDelete(_ deckName: String) {
    //        deleteDeck = deckName
    //        showAlert.toggle()
    //    }
    
    func selectDeck(_ deckHeader: DeckHeader) {
        selectedDeckId = deckHeader.name
    }
    
    func isActiveDeck(_ deckId: String) -> Bool {
        selectedDeckId == deckId
    }
}
