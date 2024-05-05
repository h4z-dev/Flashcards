//
//  AuthenticationModel.swift
//  flashcards
//
//  Created by Harris Vandenberg on 5/5/2024.
//

import Foundation

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn
import GoogleSignInSwift

protocol AuthenticationFormProtocol{
    var formIsValid: Bool {get}
}

@MainActor
class AuthenticationModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currrentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch{
            print("DEBUG: unable to login user with error: \(error.localizedDescription)")
        }
    }

    
    func createUser(withEmail email: String, password: String, fullname: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch{
            print("DEBUG: ERROR TO create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()   //signs out on firebase
            self.userSession = nil      //signs out and wipes user data
            self.currrentUser = nil     //wipes out current user data model
        }
        catch{
            print ("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(){
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("test_Authentication_users").document(uid).getDocument() else { return }
       // guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currrentUser = try? snapshot.data(as: User.self)
        print("DEBUG: CURRENT USER IS \(String(describing: self.currrentUser ?? nil))")
    }
}
