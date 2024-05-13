//
//  CreateCardViewModel.swift
//  flashcards


import Foundation

class CreateCardViewModel : ObservableObject {
    @Published var front: String = ""
    @Published var back: String = ""
}
