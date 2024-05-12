//
//  LoginErrors.swift
//  flashcards
//
//  Created by Harris Vandenberg on 5/5/2024.
//

import Foundation

//TODO: SPlit into multiple sections

enum LoginErrors: Error {
    case GoogleAuthFail
    case deckALreadyExists
    case cardDoesntExist
}
