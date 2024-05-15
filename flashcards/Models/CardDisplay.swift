//
//  CardDisplay.swift
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
            VStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(color)
                    .rotation3DEffect(
                        Angle(degrees: flipped && index == deckModel.deck.cards.count-1 ? Double(90) : Double()),
                        axis: (x: Double(0.0), y: Double(1.0), z: Double(0.0))
                    )
                    .animation(flipped && index == deckModel.deck.cards.count-1  ? .linear(duration: 0.15) : .linear(duration:0.15).delay(0.15), value: flipped && index == deckModel.deck.cards.count-1 )
                    .offset(x: CGFloat(abs((deckModel.deck.cards.count - 1) - index) * 5), y: CGFloat(index * -3))
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    .onReceive(deckModel.$flipped, perform: { flipped in
                        self.flipped = flipped
                    })
                    .onReceive(deckModel.$currentCard, perform: { currentCard in
                        withAnimation(.easeInOut){
                            self.currentIndex = currentCard.index
                        }                    })
            }
            Text(text)
                .foregroundStyle(flipped ? Color(.clear) : Color(.black))
                .animation(flipped ? .linear : .linear.delay(0.15))
        }
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
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(color)
                    .rotation3DEffect(
                        Angle(degrees: flipped && index == deckModel.deck.cards.count-1  ? Double() : Double(90)),
                        axis: (x: Double(0.0), y: Double(1.0), z: Double(0.0))
                    )
                    .animation(flipped && index == deckModel.deck.cards.count-1  ? .linear(duration: 0.15).delay(0.15) : .linear(duration: 0.15).delay(0.15), value: flipped && index == deckModel.deck.cards.count-1 )
                    .offset(x: CGFloat(abs((deckModel.deck.cards.count - 1) - index) * 5), y: CGFloat(index * -3))
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    .onReceive(deckModel.$flipped, perform: { flipped in
                        self.flipped = flipped
                    })
                    .onReceive(deckModel.$currentCard, perform: { currentCard in
                        withAnimation(.easeInOut){
                            self.currentIndex = currentCard.index
                        }
                    })
            }
            Text(text)
                .foregroundStyle(flipped ? Color(.black) : Color(.clear))
                .animation(flipped ? .linear.delay(0.15) : .linear)
        }
    }
}
