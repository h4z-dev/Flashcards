//
//  DeckView.swift
//  flashcards
//
//  Created by Jacob Goodridge on 7/5/2024.
//

import SwiftUI

struct DeckView: View {
    @StateObject var viewModel: DeckViewModel
    @Environment(\.dismiss) var dismiss
    var deckName: String
    
    init(deckHeader: DeckHeader) {
        _viewModel = StateObject(wrappedValue: DeckViewModel(deckHeader: deckHeader))
        self.deckName = deckHeader.name
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(0..<viewModel.deck.cards.count, id: \.self) { index in
                    GroupBox(label: Text(viewModel.deck.cards[index].front)) {
                        Button(action: {
                            viewModel.cardTapped(index: index)
                        }) {
                            Text(viewModel.deck.cards[index].back)
                        }
                    }
                }
            }.padding()
            
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    viewModel.addButtonPressed()
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                }
            } .padding()
        } .navigationTitle(deckName)
    }
}

#Preview {
    DeckView(deckHeader: DeckHeader(name: "0")).environmentObject(DeckViewModel(userId: "i95mtNWHzgalaetnaMEbPX8n52I2", deckHeader: DeckHeader(name: "0")))
}
