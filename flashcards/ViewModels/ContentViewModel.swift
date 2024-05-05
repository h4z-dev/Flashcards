//
//  ContentViewModel.swift
//  flashcards
//
//  Created by Harris Vandenberg on 5/5/2024.
//

import Foundation

class ContentViewModel : ObservableObject {
    var authModel: AuthenticationModel
    
    init(authModel: AuthenticationModel) {
        self.authModel = authModel
    }
}
