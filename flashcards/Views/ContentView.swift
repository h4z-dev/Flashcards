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
            if viewModel.authModel.userSession != nil {
                HomeView(authenticationModel: viewModel.authModel)
            } else {
                // loginScreen
                LoginView(authenticationModel: viewModel.authModel).onOpenURL { url in
                    // Handle Google Oauth URL
                    GIDSignIn.sharedInstance.handle(url)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
