//
//  User.swift
//  flashcards
//
//  Created  on 5/5/2024.
//

import Foundation

struct User: Identifiable, Codable{
    let id: String
    let fullname: String
    let email: String
    let googleSignIn: Bool
    let emailSignIn: Bool
    
    var initals: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Ab Cd", email: "testing123@gmail.com", googleSignIn: false, emailSignIn: true)
}
