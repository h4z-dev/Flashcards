//
//  DeckView.swift
//

import SwiftUI

/// Displays a single deck of flashcards.
struct DeckView: View {
    @StateObject var viewModel: DeckViewModel
    @Environment(\.dismiss) var dismiss
    var deckName: String
    @AppStorage("userId") var userId: String = ""
    
    /// Initialises the view with a given deck header
    /// - Parameter deckHeader: Header  for the deck, `DeckHeader`
    init(deckHeader: DeckHeader) {
        _viewModel = StateObject(wrappedValue: DeckViewModel(deckHeader: deckHeader))
        self.deckName = deckHeader.name
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (viewModel.editingDeck) {
                    ListCardView()
                        .environmentObject(viewModel)
                } else {
                    if (!viewModel.isEmpty()) {
                        DisplayFlashCards()
                            .environmentObject(viewModel)
                    }
                }
                
                //MARK: - Bottom buttons Editing and new card
                
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
                    
                    FloatingActionNavigationLink(iconName: "plus", destination: CardModificationView(title: "Create new card")
                        .environmentObject(viewModel))
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
