//
//  CardDisplay.swift
//  flashcards
//
//  Created by Jacob Goodridge on 12/5/2024.
//

import Foundation
import SwiftUI

struct CardDisplay: View {
    var text: String = ""
    var color: Color = .white
    
    init(text: String, color: Color) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(color)
        Text(text)
    }
}
