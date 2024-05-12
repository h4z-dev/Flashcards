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
        NavigationView {
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
                    
                    ScrollView {
                        ForEach(viewModel.deckHeaders, id: \.self) { deckHeader in
                            NavigationLink(destination: DeckView(deckHeader: deckHeader)) {
                                GroupBox() {
                                } label: {
                                    HStack {
                                        Image(systemName: deckHeader.symbol)
                                            .getContrastText(backgroundColor: deckHeader.color)
                                        Text(deckHeader.name)
                                            .getContrastText(backgroundColor: deckHeader.color)
                                    }
                                }
                                .backgroundStyle(Color(deckHeader.color))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .simultaneousGesture(
                                LongPressGesture().onEnded { _ in
                                    Task {
                                        viewModel.confirmDelete(deckHeader.name)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
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
                        .sheet(isPresented: $viewModel.isAddingCard, content: {
                            CreateDeckView(homeViewModel: viewModel)
                        }).padding()
                    }
                    .padding()
                }
            }
        }
        .alert("Confirm Deletion", isPresented: $viewModel.showAlert, presenting: $viewModel.deleteDeck) { deckName in
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteDeck()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: { deckName in
            Text("Are you sure you want to delete deck \"\(deckName.wrappedValue)\"?")
        }
    }
}



#Preview {
    HomeView()
        .environmentObject(AuthenticationModel())
        .environmentObject(HomeViewModel())
}
