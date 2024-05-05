//
//  User.swift
//  flashcards
//
//  Created by Harris Vandenberg on 5/5/2024.
//

import Foundation

struct User: Identifiable, Codable{
    let id: String
    let fullname: String
    let email: String
    
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
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Harris Vandenberg", email: "testing123@gmail.com")
}
