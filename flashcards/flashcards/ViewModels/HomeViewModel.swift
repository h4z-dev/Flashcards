//
//  HomeViewModel.swift
//  flashcards
//
//  Created by Jacob Goodridge on 5/5/2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    var authModel: AuthenticationModel
    
    init(authModel: AuthenticationModel) {
        self.authModel = authModel
    }
}
