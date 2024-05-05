//
//  flashcardsApp.swift
//  flashcards
//
//  Created  on 29/4/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}


@main
struct flashcardsApp: App {
    //firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authenticationModel = AuthenticationModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
