//
//  CreateCardViewModel.swift
//  flashcards
//
//  Created  on 12/5/2024.
//

import Foundation

class CreateCardViewModel : ObservableObject {
    @Published var front: String = ""
    @Published var back: String = ""
}
