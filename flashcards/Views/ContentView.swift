//
//  ContentView.swift
//  flashcards
//
//  Created  on 5/5/2024.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    
    @EnvironmentObject var authModel: AuthenticationModel

    var body: some View {
        if authModel.isAuthenticated() {
            HomeView()
        } else {
            // loginScreen
            LoginView().onOpenURL { url in
                // Handle Google Oauth URL
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationModel())
}
