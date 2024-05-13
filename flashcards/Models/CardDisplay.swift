//
//  CardDisplay.swift
//  flashcards
//
//  Created by Jacob Goodridge on 12/5/2024.
//

import Foundation
import SwiftUI

struct CardDisplayFront: View {
    var text: String = ""
    var color: Color = .white
    var index: Int
    @State var currentIndex: Int = 0
    @State var flipped: Bool = false

    @EnvironmentObject private var deckModel: DeckViewModel
    
    init(text: String, color: Color, index: Int) {
        self.text = text
        self.color = color
        self.index = index
        
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(color)
            Text(text)
        }
        .rotation3DEffect(
            Angle(degrees: flipped && index == deckModel.deck.cards.count-1 ? Double(89.99) : Double(0)),
            axis: (x: Double(0.0), y: Double(1.0), z: Double(0.0))
        )
        .opacity(flipped && index == deckModel.deck.cards.count-1  ? 0 : 1)
        .animation(flipped && index == deckModel.deck.cards.count-1  ? .linear(duration: 0.15) : .linear(duration:0.15).delay(0.15), value: flipped && index == deckModel.deck.cards.count-1 )
        .rotationEffect(Angle(degrees: Double(index) * 2 - 10))
        .offset(x: CGFloat(index * 5 - 20), y: CGFloat(index * -3))
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
        .onReceive(deckModel.$flipped, perform: { flipped in
            self.flipped = flipped
        })
        .onReceive(deckModel.$currentCard, perform: { currentCard in
            self.currentIndex = currentCard.index
        })
    }
}
struct CardDisplayBack: View {
    var text: String = ""
    var color: Color = .white
    var index: Int
    @State var currentIndex: Int = 0
    @State var flipped: Bool = false
    
    @EnvironmentObject private var deckModel: DeckViewModel
    
    init(text: String, color: Color, index: Int) {
        self.text = text
        self.color = color
        self.index = index
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(color)
            Text(text)
        }
        .rotation3DEffect(
            Angle(degrees: flipped && index == deckModel.deck.cards.count-1  ? Double() : Double(89.99)),
            axis: (x: Double(0.0), y: Double(1.0), z: Double(0.0))
        )
        .opacity( flipped && index == deckModel.deck.cards.count-1  ? 1 : 0)
        .animation(flipped && index == deckModel.deck.cards.count-1  ? .linear(duration: 0.15).delay(0.15) : .linear(duration: 0.15), value: flipped && index == deckModel.deck.cards.count-1 )
        .rotationEffect(Angle(degrees: Double(index) * 2 - 10))
        .offset(x: CGFloat(index * 5 - 20), y: CGFloat(index * -3))
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
        .onReceive(deckModel.$flipped, perform: { flipped in
            self.flipped = flipped
        })
        .onReceive(deckModel.$currentCard, perform: { currentCard in
            self.currentIndex = currentCard.index
        })
    }
}
