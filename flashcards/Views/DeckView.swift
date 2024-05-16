//
//  DeckView.swift
//

import SwiftUI

struct DeckView: View {
    @StateObject var viewModel: DeckViewModel
    @Environment(\.dismiss) var dismiss
    var deckName: String
    @AppStorage("userId") var userId: String = ""
    
    init(deckHeader: DeckHeader) {
        _viewModel = StateObject(wrappedValue: DeckViewModel(deckHeader: deckHeader))
        self.deckName = deckHeader.name
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (viewModel.editingDeck) {
                    List {
                        ForEach(viewModel.deck.cards, id: \.self) { card in
                            Text(card.front)
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    NavigationLink(destination: ModifyCardView(card: card).environmentObject(viewModel)) {
                                        Text("Edit")
                                            .font(.title.weight(.semibold))
                                            .padding()
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .shadow(radius: 1.5, x: 0, y: 1)
                                    }
                                }
                        }
                        .onMove() { from, to in
                            viewModel.moveCard(from: from, to: to)
                        }
                        .onDelete(perform: { indexSet in
                            for index in indexSet {
                                viewModel.deleteCard(index: index)
                            }
                        })
                        .listRowBackground(Color(.clear))
                    }.padding()
                        .listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.loadCards()
                        }
                } else {
                    if (!viewModel.isEmpty()) {
                        VStack {
                            ZStack {
                                ForEach(viewModel.deck.cards.indices, id: \.self) { index in
                                    CardDisplayFront(text: viewModel.currentCard.front, color: Color.white, index: index)
                                        .environmentObject(viewModel)
                                        
                                    CardDisplayBack(text: viewModel.currentCard.back, color: Color.gray, index: index)
                                        .environmentObject(viewModel)
                                }
                            }
                            
                            //BAD
                            .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 400)
                            .padding(.top, 100.0)
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    viewModel.flipped.toggle()
                                }
                            }
                            
                            Spacer()
                            
                        }
                    }
                }
                if (!viewModel.editingDeck) {
                    VStack {
                        Spacer()
                        HStack (spacing: 20) {
                            Button() {
                                viewModel.previous()
                                viewModel.flipped = false
                            } label: {
                                Text("Previous")
                                    .frame(maxWidth: .infinity, maxHeight: 48)
                                    .background(.secondAccent)
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                    .foregroundStyle(.white)
                            }
                            
                            Button() {
                                viewModel.next()
                                viewModel.flipped = false
                            } label: {
                                Text("Next")
                                    .frame(maxWidth: .infinity, maxHeight: 48)
                                    .background(.secondAccent)
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                    
                    HStack {
                        Button() {
                            viewModel.editDeck()
                        } label: {
                            Image(systemName: viewModel.editingDeck ? "book.pages" : "hammer")
                            Text(viewModel.editingDeck ? "Use" : "Edit")
                        }
                        .font(.title3.weight(.semibold))
                        .padding()
                        .foregroundColor(.black)
                        .background(.accentColorLight)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 1.5, x: 0, y: 1)
                        
                        Spacer()
                    
                        FloatingActionNavigationLink(iconName: "plus", destination: CreateCardView(deckModel: viewModel))
                            .task {
                                viewModel.updateCardIndex()
                            }
                            
                    } .padding()
                        .onAppear() {
                            Task{
                                viewModel.editingDeck.toggle()
                                viewModel.editingDeck.toggle()
                            }
                        }
                
            }
        } .navigationTitle(deckName)
    }
}

#Preview {
    DeckView(deckHeader: DeckHeader(name: "0"))
}
