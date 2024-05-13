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
            ZStack {
                if(viewModel.editingDeck) {
                    List {
                        ForEach(viewModel.deck.cards, id: \.self) { card in
                            Text(card.front)
                        }
                        .onDelete(perform: { indexSet in
                            for index in indexSet{
                                viewModel.deleteCard(index: index)
                            }
                        })
                        .onMove() { from, to in
                            viewModel.moveCard(from: from, to: to)
                        }
                        .listRowBackground(Color(.clear))
                    }.padding()
                        .toolbar{
                            EditButton()
                        }
                        .listStyle(PlainListStyle())
                } else {
                    if(!viewModel.isEmpty()) {
                        VStack {
                            ZStack {
                                CardDisplay(text: viewModel.currentCard.front, color: Color.orange)
                                    .rotation3DEffect(
                                        Angle(degrees: viewModel.flipped ? 89.99 : 0),
                                        axis: (x: 0.0, y: 1.0, z: 0.0)
                                    )
                                    .opacity(viewModel.flipped ? 0 : 1)
                                    .animation(viewModel.flipped ? .linear(duration: 0.15) : .linear(duration:0.15).delay(0.15), value: viewModel.flipped)
                                
                                CardDisplay(text: viewModel.currentCard.back, color: Color.blue)
                                    .rotation3DEffect(
                                        Angle(degrees: viewModel.flipped ? 0 : -89.99),
                                        axis: (x: 0.0, y: 1.0, z: 0.0)
                                    )
                                    .opacity( viewModel.flipped ? 1 : 0)
                                    .animation(viewModel.flipped ? .linear(duration: 0.15).delay(0.15) : .linear(duration: 0.15), value: viewModel.flipped)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 300)
                            .padding()
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    viewModel.flipped.toggle()
                                }
                            }
                            Spacer()
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    if(!viewModel.editingDeck) {
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
                            
                    } .padding()
                        .onAppear() {
                            Task{
                                viewModel.editingDeck.toggle()
                                if (viewModel.isEmpty()) {
                                    viewModel.editingDeck.toggle()
                                }
                            }
                        }
                }
            }
        } .navigationTitle(deckName)
    }
}

#Preview {
    DeckView(deckHeader: DeckHeader(name: "0"))
}
