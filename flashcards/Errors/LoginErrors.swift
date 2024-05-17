//
//  LoginErrors.swift
//

import Foundation

/// `enum` containing types of errors that can be returned.
enum LoginErrors: Error {
    case GoogleAuthFail
    case deckALreadyExists
    case cardDoesntExist
}
