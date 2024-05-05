//
//  ContentView.swift
//  flashcards
//
//  Created by Harris Vandenberg on 29/4/2024.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    init(authenticationModel: AuthenticationModel) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(authModel: authenticationModel))
    }
    
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        VStack {
            HStack {
                Text("Flashcards")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(LinearGradient(colors: [.accentColor, .secondAccent], startPoint: .leading, endPoint: .trailing))
                Spacer()
                Button{
                    Task{
                        try await AuthenticationModel().logout()
                        dismiss()
                    }
                } label: {
                    Text("LOGOUT")
                }
            }
            .padding()
            Spacer()
            HStack {
                Spacer()
                Button {
                    // Action
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(.accent)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                }
            } .padding()
        }
    }
}

#Preview {
    HomeView(authenticationModel: AuthenticationModel())
}
