//
//  HomeView.swift
//

import SwiftUI

/// Main view of the app. Displays decks of cards as a list.
struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var authModel: AuthenticationModel
    @Environment(\.dismiss) var dismiss
    
    init() {
        _viewModel = StateObject(wrappedValue: HomeViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Text("Flashcards")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(LinearGradient(colors: [.accentColor, .secondAccent], startPoint: .leading, endPoint: .trailing))
                        Spacer()
                        Button {
                            Task {
                                authModel.signOut()
                                dismiss()
                            }
                        } label: {
                            Text("LOGOUT")
                        }
                        .task {
                            if (!authModel.isAuthenticated()) {
                                dismiss()
                            }
                        }
                    }
                    .padding()
                    
                    List {
                        ForEach(viewModel.deckHeaders, id: \.self) { deckHeader in
                            NavigationLink(destination: DeckView(deckHeader: deckHeader)) {
                                HStack {
                                    Image(systemName: deckHeader.symbol)
                                        .getContrastText(backgroundColor: deckHeader.color)
                                    Text(deckHeader.name)
                                        .getContrastText(backgroundColor: deckHeader.color)
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(deckHeader.color))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                            }
                            .listRowSeparator(.hidden)
                            .buttonStyle(.plain)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteDeck)
                    }
                    .refreshable {
                        Task {
                            await viewModel.fetchDeckNames()
                        }
                    }
                    .padding(.top, 0)
                    .listStyle(PlainListStyle())
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingActionButton(iconName: "plus", action: {
                            viewModel.addButtonPressed()
                        })
                        .sheet(isPresented: $viewModel.isAddingDeck, content: {
                            CreateDeckView(homeViewModel: viewModel)
                        }).padding()
                    }
                }
            }
        }
    }
    
    /// Deletes a deck at the specified index
    /// - Parameter offsets: `IndexSet` of deck(s) to be deleted
    private func deleteDeck(at offsets: IndexSet) {
        offsets.forEach { index in
            let deckName = viewModel.deckHeaders[index].name
            Task {
                await viewModel.deleteDeck(deckName)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationModel())
        .environmentObject(HomeViewModel())
}
