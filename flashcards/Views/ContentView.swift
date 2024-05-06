//
//  ContentView.swift
//  flashcards
//
//  Created  on 5/5/2024.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    
//    @StateObject var viewModel: ContentViewModel
    @EnvironmentObject var authModel: AuthenticationModel

    var body: some View {
        Group {
            if authModel.userSession != nil {
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
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationModel())
}
