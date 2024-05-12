//
//  HomeView.swift
//  flashcards
//
//  Created  on 29/4/2024.
//

import SwiftUI

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
                            Button(action: {
                                viewModel.selectDeck(deckHeader)
                            }) {
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
                                .cornerRadius(10)
                            }
                            .listRowSeparator(.hidden)
                            .buttonStyle(PlainButtonStyle())
                            .listRowBackground(Color(.clear))
                            .background(
                                NavigationLink(
                                    destination: DeckView(deckHeader: deckHeader),
                                    isActive: .init(
                                        get: { viewModel.isActiveDeck(deckHeader.name) },
                                        set: { _ in }
                                    )
                                ) {
                                    EmptyView()
                                }
                                    .hidden()
                            )
                        }
                        .onDelete(perform: deleteDeck)
                    }
                }
                .padding(.top, 0)
                .listStyle(PlainListStyle())
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            viewModel.addButtonPressed()
                        } label: {
                            Image(systemName: "plus")
                                .font(.title.weight(.semibold))
                                .padding()
                                .background(.accent)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 4, x: 0, y: 4)
                        }
                        .sheet(isPresented: $viewModel.isAddingDeck, content: {
                            CreateDeckView(homeViewModel: viewModel)
                        }).padding()
                    }
                }
            }
        }
    }
    
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
