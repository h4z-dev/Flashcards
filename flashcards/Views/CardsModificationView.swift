//
//  CreateCardView.swift
//

import SwiftUI

struct CardsModificationView: View {
    @StateObject var viewModel: CardsModificationViewModel
    @EnvironmentObject private var deckModel: DeckViewModel
    @Environment(\.dismiss) var dismiss
    var title: String
    
    init(title: String) {
        _viewModel = StateObject(wrappedValue: CardsModificationViewModel())
        self.title = title
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Text(title)
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
                Task {
                    await deckModel.createNewCard(front: viewModel.front, back: viewModel.back)
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
    CardsModificationView(title: "Create New Card Dynamic!")
        .environmentObject(DeckViewModel(deckHeader: DeckHeader(name: "0")))
}
