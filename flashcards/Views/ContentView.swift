//
//  ContentView.swift
//

import SwiftUI
import GoogleSignIn

/// Primary content view of the app, switching the user between the login screen and home view depending on the authentication state of the user managed by `AuthenticationModel`.
struct ContentView: View {
    
    @EnvironmentObject var authModel: AuthenticationModel

    var body: some View {
        if authModel.isAuthenticated() {
            HomeView()
        } else {
            /// Display the login screeen
            LoginView().onOpenURL { url in
                /// Handle Google OAuth URL
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationModel())
}
