//
//  CreateCardViewModel.swift
//

import Foundation

class CardsModificationViewModel : ObservableObject {
    @Published var front: String = ""
    @Published var back: String = ""
}
