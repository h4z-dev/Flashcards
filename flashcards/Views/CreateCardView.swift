//
//  CreateCardView.swift
//  flashcards
//
//  Created  on 12/5/2024.
//

import SwiftUI

struct CreateCardView: View {
    @StateObject var viewModel: CreateCardViewModel
    @StateObject var deckViewModel: DeckViewModel
    @Environment(\.dismiss) var dismiss

    init(deckModel : DeckViewModel) {
        _viewModel = StateObject(wrappedValue: CreateCardViewModel())
        _deckViewModel = StateObject(wrappedValue: deckModel)
    }
    
    var body: some View {
        VStack {
            Text("Create new Card")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.vertical)
                .foregroundColor(.primary)
            
            TextField("Front of card", text: $viewModel.front)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            
            TextField("Back of card", text: $viewModel.back)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            Button {
                Task{
                    await deckViewModel.createNewCard(front: viewModel.front, back: viewModel.back)
                    dismiss()
                }
            } label: {
                Label("Add card", systemImage: "chevron.right")
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    .foregroundStyle(Color(.white))
                    .background(Color(.blue))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    CreateCardView(deckModel: DeckViewModel(deckHeader: DeckHeader(name: "0")))
}
