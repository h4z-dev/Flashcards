//
// ListCardCView.swift
//

import SwiftUI

/// The list view for viewing cards
struct ListCardView: View {
    
    @EnvironmentObject private var deckModel: DeckViewModel
    
    var body: some View {
        List {
            ForEach(deckModel.deck.cards, id: \.self) { card in
                Text(card.front)
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        NavigationLink(destination: ModifyCardView(card: card).environmentObject(deckModel)) {
                            Text("Edit")
                                .font(.title.weight(.semibold))
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 1.5, x: 0, y: 1)
                        }
                    }
            }
            .onMove() { from, to in
                deckModel.moveCard(from: from, to: to)
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    deckModel.deleteCard(index: index)
                }
            })
            .listRowBackground(Color(.clear))
        }
        .padding()
        .listStyle(PlainListStyle())
        .refreshable {
            deckModel.loadCards()
        }
    }
}
