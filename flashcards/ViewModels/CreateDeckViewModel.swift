//
//  CreateDeckViewModel.swift
//

import Foundation
import SwiftUI // For colour options
import FirebaseCore
import FirebaseFirestore

class CreateDeckViewModel : ObservableObject {
    @Published var deckName: String = ""
    @Published var deckColor: Color = .gray
    @Published var deckLogo: String = "rectangle.on.rectangle"
}
