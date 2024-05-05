//
//  GoogleIDSignIn.swift
//  flashcards
//
//  Created  on 5/5/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignInSwift
import GoogleSignIn

class googleIDSignInViewModel {
    
    func signIn { [weak self] user, error in
        guard let self = self else { return }
        if let error = error {
            // Handle error
            print(error.localizedDescription)
            return
        }

        guard let authentication = user?.authentication else { return }
        let credential = GoogleAuthProvider.credential(with: authentication)
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                // Handle error
                print(error.localizedDescription)
                return
            }

            // User successfully signed in
            print("User signed in with Google!")
        }
    }
}
