//
//  SystemErrors.swift
//

import Foundation

/// `enum` containing types of errors that can be returned.
enum SystemErrors: Error {
    case deckALreadyExists
    case cardDoesntExist
}
