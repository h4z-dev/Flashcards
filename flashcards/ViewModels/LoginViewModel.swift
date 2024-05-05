//
//  LoginViewModel.swift
//  flashcards
//
//  Created by Harris Vandenberg on 5/5/2024.
//

import Foundation

class LoginViewModel: ObservableObject {
    var authModel: AuthenticationModel
    
    init(authModel: AuthenticationModel) {
        self.authModel = authModel
    }
}
