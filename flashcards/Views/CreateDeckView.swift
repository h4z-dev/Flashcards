//
//  CreateDeckView.swift
//  flashcards
//
//  Created  on 10/5/2024.
//

import SwiftUI
import SFSymbolsPicker

struct CreateDeckView: View {
    @StateObject var viewModel: CreateDeckViewModel
    @StateObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var isPresented = false
    
    init(homeViewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: CreateDeckViewModel())
        _homeViewModel = StateObject(wrappedValue: homeViewModel)
    }
    
    var body: some View {
        VStack {
            Text("Create new Deck")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.vertical)
                .foregroundColor(.primary)
            
            TextField("Name of Deck", text: $viewModel.deckName)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            
            HStack {
                Label("Deck Colour", systemImage: "paintbrush.fill")
                    .fontWeight(.semibold)
                    .padding(.vertical, 10)
                
                Spacer()
                
                ColorPicker("", selection: $viewModel.deckColor, supportsOpacity: false)
                    .labelsHidden()
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                isPresented.toggle()
            }) {
                Label("Change Symbol", systemImage: viewModel.deckLogo)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(viewModel.deckColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            .sheet(isPresented: $isPresented, content: {
                SymbolsPicker(selection: $viewModel.deckLogo, title: "Pick a symbol", autoDismiss: true)
            })
            
            Button(action: {
                Task {
                    do {
                        try await homeViewModel.createNewDeck(deckName: viewModel.deckName, deckColor: viewModel.deckColor, deckLogo: viewModel.deckLogo)
                        dismiss()
                    } catch {
                        print("Error creating new deck")
                    }
                }
            }) {
                Label("Create New Deck", systemImage: "arrow.forward.square.fill")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.accentColor) // Use accent color for primary actions
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            .disabled(!formIsValid)
        }
        .padding(.vertical)
        Spacer()
    }
}

extension CreateDeckView {
    var formIsValid: Bool {
        return !viewModel.deckName.isEmpty
        && viewModel.deckName != "DECK_HEADER"
    }
}

#Preview {
    CreateDeckView(homeViewModel: HomeViewModel())
        .environmentObject(AuthenticationModel())
        .environmentObject(CreateDeckViewModel())
}
