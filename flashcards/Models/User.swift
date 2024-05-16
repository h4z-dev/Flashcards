//
//  User.swift
//  flashcards
//

import Foundation

/// Structure to represent a user of Flashcards
struct User: Identifiable, Codable {
    let id: String              /// Unique ID of the user
    let fullname: String        /// Full name of the user
    let email: String           /// Email of the user
    let googleSignIn: Bool      /// Is the user signed in with Google OAuth? (Currently always false)
    let emailSignIn: Bool       /// Is the user signed in with an Email address?
    
    /// The initials of the user based on their provided full name.
    var initals: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

/// Mock user used for testing purposes.
extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Harris Vandenberg", email: "JacobGoodridge@gmail.com", googleSignIn: false, emailSignIn: true)
}
