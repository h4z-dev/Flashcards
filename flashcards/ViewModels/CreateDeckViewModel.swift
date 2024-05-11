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
    @Published var deckColor: Color = .white
    @Published var deckLogo: String = "star.fill"
    
}
