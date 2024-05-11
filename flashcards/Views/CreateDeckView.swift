//
//  CreateDeckView.swift
//  flashcards
//
//  Created by Harris Vandenberg on 10/5/2024.
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
        VStack{
            Text("Create new Deck")
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.heavy)
                .padding(.vertical)
            TextField("Name of Deck", text: $viewModel.deckName)
                .font(.system(size: 14))
                .padding(.horizontal)
                .textFieldStyle(.roundedBorder)
            ColorPicker("Deck Colour:", selection: $viewModel.deckColor, supportsOpacity: false)
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
                .padding()
            
            Button(){
                isPresented.toggle()
            } label: {
                HStack{
                    Text("Change Symbol:")
                    Image(systemName: viewModel.deckLogo)
                }
                .foregroundStyle(Color.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(viewModel.deckColor)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .sheet(isPresented: $isPresented, content: {
                SymbolsPicker(selection: $viewModel.deckLogo, title: "Pick a symbol", autoDismiss: true)
            }).padding()
            
            
            Button(){
                Task{
                    do{
                        try await homeViewModel.createNewDeck(deckName: viewModel.deckName, deckColor: viewModel.deckColor, deckLogo: viewModel.deckLogo)
                        dismiss()
                    }
                    catch{
                        print("Error creating new deck")
                    }
                }
            } label: {
                HStack{
                    Text("Create New Deck")
                    Image(systemName: "arrow.forward.square.fill")
                }
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                .foregroundStyle(Color.white)
                .background(Color.blue)
            }
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .disabled(!formIsValid)
        }
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
