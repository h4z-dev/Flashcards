//
//  ModifyCardView.swift
//  flashcards
//
//  Created  on 13/5/2024.
//

import SwiftUI

struct ModifyCardView: View {
    
    @StateObject var viewModel : ModifyCardViewModel
    @EnvironmentObject private var deckViewModel: DeckViewModel
    @Environment(\.dismiss) var dismiss
    
    init(card: Card) {
        _viewModel = StateObject(wrappedValue: ModifyCardViewModel(card: card))
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Spacer()
            Text("Modify Card")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.vertical)
                .foregroundColor(.primary)
            
            TextField("Front of card", text: $viewModel.cardFront)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            
            TextField("Back of card", text: $viewModel.cardBack)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            Button {
                viewModel.updateCard()
                Task{
                    deckViewModel.updateCard(card: viewModel.card)
                    dismiss()
                }
            } label: {
                Label("Modify card", systemImage: "square.and.pencil")
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    .foregroundStyle(Color(.white))
                    .background(Color(.blue))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
            }
        }
        .padding(.bottom, 100)
    }
}

#Preview {
    ModifyCardView(card: Card("Front", "Back", index: 0))
        .environmentObject(DeckViewModel(deckHeader: DeckHeader(name: "0")))
}
