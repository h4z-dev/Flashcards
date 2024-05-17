//
//  AuthenticationModel.swift
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore
import SwiftUI

protocol AuthenticationFormProtocol {
    var formIsValid: Bool {
        get
    }
}

@MainActor
class AuthenticationModel: ObservableObject {
    let userDefaults = UserDefaults.standard
    @Published var userSession: FirebaseAuth.User?
    @Published var currrentUser: User?
    @AppStorage("userId") var userId: String = ""
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    // MARK: - Email Sign In
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: unable to login user with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = User(id: result.user.uid, fullname: fullname, email: email, googleSignIn: false, emailSignIn: true)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        } catch{
            print("DEBUG: ERROR TO create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do{
            try Auth.auth().signOut()   // signs out on Firebase
            self.userSession = nil      // signs out and wipes user data
            self.currrentUser = nil     // wipes out current user data model
        }
        catch {
            print ("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
        print("user should be signed out:")
        if (self.userSession != nil) {
            print("User is still signed in: \(String(describing: self.currrentUser ?? nil))")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userId = uid
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currrentUser = try? snapshot.data(as: User.self)
    }
    
    func isAuthenticated() -> Bool {
        return self.userSession != nil && self.userId != ""
    }
}
