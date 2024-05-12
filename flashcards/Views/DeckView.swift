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
                if(viewModel.editingDeck){
                    List {
                        ForEach(0..<viewModel.deck.cards.count, id: \.self) { index in
                            Text(viewModel.deck.cards[index].front)
                        }
                        .listRowBackground(Color(.clear))
                    }.padding()
                        .listStyle(PlainListStyle())
                } else {
                    if(!viewModel.isEmpty()) {
                        VStack {
                            ZStack {
                                CardDisplay(text: viewModel.currentCard.front, color: Color.orange)
                                    .rotation3DEffect(
                                        Angle(degrees: viewModel.flipped ? 89.99 : 0),
                                        axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
                                    )
                                    .opacity(viewModel.flipped ? 0 : 1)
                                    .animation(viewModel.flipped ? .linear(duration: 0.1) : .linear(duration:0.1).delay(0.1), value: viewModel.flipped)
                                CardDisplay(text: viewModel.currentCard.back, color: Color.blue)
                                    .rotation3DEffect(
                                        Angle(degrees: viewModel.flipped ? 0 : -89.99),
                                        axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
                                    )
                                    .opacity( viewModel.flipped ? 1 : 0)
                                    .animation(viewModel.flipped ? .linear(duration: 0.2).delay(0.1) : .linear(duration: 0.1), value: viewModel.flipped)
                            }
                            .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 300)
                            .padding()
                            .onTapGesture {
                                withAnimation(.easeIn){
                                    viewModel.flipped.toggle()
                                }
                            }
                            Spacer()
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack (spacing: 20) {
                        Button() {
                            viewModel.previous()
                            viewModel.flipped = false
                        } label: {
                            Text("Previous")
                        }
                        .frame(maxWidth: .infinity, maxHeight: 48)                        .background(.secondAccent)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .foregroundStyle(.white)
                        
                        Button() {
                            viewModel.next()
                            viewModel.flipped = false
                        } label: {
                            Text("Next")
                        }
                        .frame(maxWidth: .infinity, maxHeight: 48)
                        .background(.secondAccent)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                    HStack {
                        Button() {
                            viewModel.editingDeck.toggle()
                        } label: {
                            Image(systemName: viewModel.editingDeck ? "book.pages" : "hammer")
                            Text(viewModel.editingDeck ? "Use" : "Edit")
                        }
                        Spacer()
                        NavigationLink(destination: CreateCardView(deckModel: viewModel)) {
                            FloatingActionButton(iconName: "plus") {
                                
                            }
                        }
                    } .padding()
                        .onAppear() {
                            Task{
                                viewModel.loadCards()
                                viewModel.editingDeck.toggle()
                                if (viewModel.isEmpty()) {
                                    viewModel.editingDeck.toggle()
                                }
                            }
                        }
                }
            }
        } .navigationTitle(deckName)
            .onAppear() {
                Task {
                    viewModel.loadCards()
                }
            }
    }
}

#Preview {
    DeckView(deckHeader: DeckHeader(name: "0"))
}
