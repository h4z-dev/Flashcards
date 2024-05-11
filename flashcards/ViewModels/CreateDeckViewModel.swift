//
//  CreateDeckViewModel.swift
//  flashcards
//
//  Created by Harris Vandenberg on 10/5/2024.
//

import Foundation
//for colour options
import SwiftUI

class CreateDeckViewModel : ObservableObject {
    @Published var deckName: String = ""
    @Published var deckColor: Color = .gray
    @Published var deckLogo: String = "rectangle.on.rectangle"
    
    func createNewDeck() {
        var n
        n = n+1
    }
}
