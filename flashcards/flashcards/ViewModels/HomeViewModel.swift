//
//  HomeViewModel.swift
//  flashcards
//
//  Created by Jacob Goodridge on 5/5/2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    let db = Firestore.firestore()
    var flashcard = Deck()
    
    init() {
//        flashcard.add(front: "test1", back: "test2")
//        flashcard.add(front: "aaa", back: "bbb")
//        flashcard.add(front: "111", back: "222")
//        print(flashcard.toString())
        Task {
//            await fireStoreExample()
//            await addCards()
            await getCards(deckId: "0")
        }
    }
    
    func addCards() async {
        do {
            try await db.collection("users").document("USER-ID-GOES-HERE").collection("decks").document("0").setData(flashcard.toArray())
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    func getCards(deckId: String) async {
        let userId = "USER-ID-GOES-HERE"
        do {
            // Attempt to fetch the whole deck first, so we can catch an error early if it occurs.
            let deckDocument = try await db.collection("users").document(userId).collection("decks").document(deckId).getDocument()
            if let data = deckDocument.data() {
                var deck = Deck()
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
            print("Error retrieving deck: \(error)")
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
    
    }
}
