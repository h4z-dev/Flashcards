//
//  flashcardsApp.swift
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
        
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
}


@main
struct flashcardsApp: App {
    // Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authModel = AuthenticationModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
        }
    }
}

//TODO:
//@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//@StateObject var viewModel = AuthenticationModel()

//var body: some Scene {
//WindowGroup {
//  NavigationView {
//    ContentView()
//          .environmentObject(viewModel)
