//
//  CreateCardView.swift
//  flashcards
//
//  Created by Harris Vandenberg on 12/5/2024.
//

import SwiftUI

struct CreateCardView: View {
    @State var temporaryTextHolder: String = ""
    @StateObject var viewModel: CreateCardViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: CreateCardViewModel())
    }
    
    var body: some View {
        VStack {
            Text("Create new Card")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.vertical)
                .foregroundColor(.primary)
            
            TextField("Front of card", text: $temporaryTextHolder)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            
            TextField("Back of card", text: $temporaryTextHolder)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            Button {
                
            } label: {
                Label("Add card", systemImage: "right.arrow")
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    .foregroundStyle(Color(.white))
                    .background(Color(.blue))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    CreateCardView()
}
