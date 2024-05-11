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
    
    init(deckHeder: DeckHeader) {
        _viewModel = StateObject(wrappedValue: DeckViewModel(deckHeader: deckHeder))
        self.deckName = deckHeder.name
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(0..<viewModel.cards.contents.count, id: \.self) { index in
                    GroupBox(label: Text(viewModel.cards.contents[index][0])) {
                        Button(action: {
                            viewModel.cardTapped(index: index)
                        }) {
                            Text(viewModel.cards.contents[index][1])
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
    DeckView(deckHeder: DeckHeader(name: "0")).environmentObject(DeckViewModel(userId: "i95mtNWHzgalaetnaMEbPX8n52I2", deckHeader: DeckHeader(name: "0")))
}
