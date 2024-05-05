//
//  GoogleIDSignIn.swift
//  flashcards
//
//  Created by Harris Vandenberg on 5/5/2024.
//

import Foundation
import Firebase
import GoogleSignIn
import SwiftUI

struct GoogleIDSignInView: View {
    @EnvironmentObject var authModel: AuthenticationModel
    let googleIDSignInViewModel
    var body: some View {
        Button(action: {
            signIn()
        }, label: {
            Text("Sign in with Google")
        })
    }
}
