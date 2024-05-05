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
        flashcard.add(front: "test1", back: "test2")
        flashcard.add(front: "aaa", back: "bbb")
        flashcard.add(front: "111", back: "222")
        print(flashcard.toString())
        Task {
//            await fireStoreExample()
            await addCards()
        }
    }
    
    func addCards() async {
        do {
            try await db.collection("users").document("test").collection("decks").document("0").setData(flashcard.toArray())
        } catch {
            print("Error adding document: \(error)")
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
