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
    
    init(deckHeder: DeckHeader, userId: String) {
        _viewModel = StateObject(wrappedValue: DeckViewModel(userId: userId, deckHeader: deckHeder))
        self.deckName = deckHeder.name
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                if(viewModel.editingDeck){
                    List {
                        ForEach(0..<viewModel.deck.cards.count, id: \.self) { index in
                            Text(viewModel.deck.cards[index].front)
                        }
                    }.padding()
                } else{
                    if(!viewModel.isEmpty()){
                        VStack{
                            ZStack{
                                CardDisplay(text: viewModel.currentCard().front, color: Color.orange)
                                    .rotation3DEffect(
                                        Angle(degrees: viewModel.flipped ? 89.99 : 0),
                                                              axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
                                    )
                                    .animation(viewModel.flipped ? .linear.delay(0.35) : .linear, value: viewModel.flipped)
                                CardDisplay(text: viewModel.currentCard().back, color: Color.blue)
                                    .rotation3DEffect(
                                        Angle(degrees: viewModel.flipped ? 0 : -89.99),
                                                              axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
                                    )
                                    .animation(viewModel.flipped ? .linear : .linear.delay(0.35), value: viewModel.flipped)
                            }
                            .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 300)
                            .padding()
                            .onTapGesture {
                                withAnimation(.easeInOut){
                                    viewModel.flipped.toggle()
                                }
                            }
                            Spacer()
                        }
                    }
                }
                VStack{
                    Spacer()
                    HStack {
                        Button(){
                            viewModel.editingDeck.toggle()
                        } label: {
                            Image(systemName: viewModel.editingDeck ? "book.pages" : "hammer")
                            Text(viewModel.editingDeck ? "Use" : "Edit")
                        }
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
                                viewModel.editingDeck.toggle()
                                if(viewModel.isEmpty()){
                                    viewModel.editingDeck.toggle()
                                }
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
    DeckView(deckHeder: DeckHeader(name: "0"), userId: "i95mtNWHzgalaetnaMEbPX8n52I2").environmentObject(DeckViewModel(userId: "i95mtNWHzgalaetnaMEbPX8n52I2", deckHeader: DeckHeader(name: "0")))
}

struct CardDisplay: View {
    var text: String = ""
    var color: Color = .white
    
    init(text: String, color: Color) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(color)
        Text(text)
    }
}
