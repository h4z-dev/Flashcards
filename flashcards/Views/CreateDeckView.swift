//
//  CreateDeckView.swift
//  flashcards
//
//  Created  on 10/5/2024.
//

import SwiftUI
import SFSymbolsPicker

struct CreateDeckView: View {
    @StateObject var viewModel: CreateDeckViewModel
    @EnvironmentObject var authModel: AuthenticationModel
    
    @State private var isPresented = false
    
    init() {
        _viewModel = StateObject(wrappedValue: CreateDeckViewModel())
    }
    
    var body: some View {
        VStack{
            Text("Create new Deck")
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.heavy)
                .padding(.vertical)
            HStack{
                VStack{
                    Text("Add deck Name")
                        .foregroundStyle(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                    TextField("Name of Deck", text: $viewModel.deckName)
                        .font(.system(size: 14))
                        .padding(.horizontal)
                }
                
                VStack{
                    Text("Deck Colour")
                        .foregroundStyle(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                    ColorPicker("", selection: $viewModel.deckColor, supportsOpacity: false)
                }
                Spacer()
            }
            .padding()
            Button(){
                isPresented.toggle()
            } label: {
                HStack{
                    Text("Change Symbol")
                    Image(systemName: viewModel.deckLogo)
                }
                .foregroundStyle(Color.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .cornerRadius(20)
            .background(.accent)
            .sheet(isPresented: $isPresented, content: {
                SymbolsPicker(selection: $viewModel.deckLogo, title: "Pick a symbol", autoDismiss: true)
                            }).padding()
            Spacer()
            
        }
    }
}

#Preview {
    CreateDeckView()
}
