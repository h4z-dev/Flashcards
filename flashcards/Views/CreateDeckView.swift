//
//  CreateDeckView.swift
//  flashcards
//
//  Created by Harris Vandenberg on 10/5/2024.
//

import SwiftUI

struct CreateDeckView: View {
    @StateObject var viewModel: CreateDeckViewModel
    @EnvironmentObject var authModel: AuthenticationModel
    
    init() {
        _viewModel = StateObject(wrappedValue: CreateDeckViewModel())
    }
    
    var body: some View {
        VStack{
            Text("Create new Deck")
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.heavy)
            Text("Add deck Name")
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            TextField("Name of Deck", text: $viewModel.deckName)
                .font(.system(size: 14))
                .padding(.horizontal)
            Text("Deck Colour")
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            ColorPicker("Deck Colour", selection: $viewModel.deckColor, supportsOpacity: false)
            TextField("Name of Deck", text: $viewModel.deckName)
                .font(.system(size: 14))
                .padding(.horizontal)
            Text("Add deck Name")
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            TextField("Name of Deck", text: $viewModel.deckName)
                .font(.system(size: 14))
                .padding(.horizontal)
            Spacer()
            
        }
    }
}

#Preview {
    CreateDeckView()
}
