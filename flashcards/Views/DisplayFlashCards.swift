//
//  DisplayFlashCards.swift
//

import SwiftUI

/// Displays the flashcards.
struct DisplayFlashCards: View {
    @EnvironmentObject private var deckModel: DeckViewModel
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(deckModel.deck.cards.indices, id: \.self) { index in
                    CardDisplayFront(text: deckModel.currentCard.front, color: Color.white, index: index)
                        .environmentObject(deckModel)
                    
                    CardDisplayBack(text: deckModel.currentCard.back, color: Color.gray, index: index)
                        .environmentObject(deckModel)
                }
            }
            
            .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 400)
            .padding(.top, 100.0)
            .onTapGesture {
                withAnimation(.easeIn) {
                    deckModel.flipped.toggle()
                }
            }
            
            Spacer()
            
        }
    }
}
