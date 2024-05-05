//
//  LoginViewModel.swift
//  flashcards
//
//  Created  on 5/5/2024.
//

import Foundation

class LoginViewModel: ObservableObject {
    var authModel: AuthenticationModel
    
    init(authModel: AuthenticationModel) {
        self.authModel = authModel
    }
}
