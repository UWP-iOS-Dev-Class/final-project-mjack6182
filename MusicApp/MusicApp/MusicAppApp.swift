//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Jack Miller on 4/7/25.
//

import SwiftUI
import Firebase
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct MusicAppApp: App {
    @StateObject var authVM = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            if authVM.user == nil {
//                // If there is no user logged in, show the onboarding flow.
//                OnboardingView()
//                    .environmentObject(authVM)
//            } else {
//                // Once the user is logged in, show the main app content.
//                ContentView()
//                    .environmentObject(authVM)
//            }
            ContentView()
        }
    }
}
