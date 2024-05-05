//
//  ContentView.swift
//  flashcards
//
//  Created by Harris Vandenberg on 5/5/2024.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                HomeView();
            } else{
                LoginView()
                //loginScreen
            }
        }
    }
}

#Preview {
    ContentView()
}
