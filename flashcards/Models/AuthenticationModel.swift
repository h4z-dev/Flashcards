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
    var formIsValid: Bool {get}
}

@MainActor
class AuthenticationModel: ObservableObject {
    let userDefaults = UserDefaults.standard
    @Published var userSession: FirebaseAuth.User?
    @Published var currrentUser: User?
    @AppStorage("userId") var userId: String = ""
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task{
            await fetchUser()
        }
    }
    
    
    // MARK: - Google Sign In
    
    func googleOauth() async throws {
        // Google sign in
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("no firbase clientID found")
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Get rootView
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = scene?.windows.first?.rootViewController
        else {
            fatalError("There is no root view controller!")
        }
        
        // Google sign in authentication response
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        )
        
        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
            throw LoginErrors.GoogleAuthFail
        }
        
        // Firebase auth
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken, accessToken: user.accessToken.tokenString
        )
        
        await fetchUser()
        
    }
    
    func logout() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
    
    // MARK: - Email Sign In
    
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
        catch{
            print ("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
        print("user should be signed out:")
        if (self.userSession != nil){
            print("User is still signed in: \(String(describing: self.currrentUser ?? nil))")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userId = uid
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currrentUser = try? snapshot.data(as: User.self)
        print("DEBUG: CURRENT USER IS \(String(describing: self.currrentUser ?? nil))")
    }
    
    func isAuthenticated() -> Bool {
        return self.userSession != nil && self.userId != ""
    }
}
