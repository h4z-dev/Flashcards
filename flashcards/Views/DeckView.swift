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
        NavigationView{
            ZStack {
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
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: CreateCardView(deckModel: viewModel)){
                            Image(systemName: "plus")
                                .font(.title.weight(.semibold))
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 4, x: 0, y: 4)
                        }
                    } .padding()
                        .onAppear(){
                            Task{
                                viewModel.loadCards()
                            }
                        }
                }
            }
        } .navigationTitle(deckName)
            .onAppear(){
                Task{
                    viewModel.loadCards()
                }
            }
    }
}

#Preview {
    DeckView(deckHeder: DeckHeader(name: "0")).environmentObject(DeckViewModel(userId: "i95mtNWHzgalaetnaMEbPX8n52I2", deckHeader: DeckHeader(name: "0")))
}
