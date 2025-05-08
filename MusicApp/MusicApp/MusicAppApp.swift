//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Jack Miller on 4/7/25.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
   
    FirebaseApp.configure()
    
  
    AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
      
    return true
  }
}
    @main
    struct MusicAppApp: App {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        @StateObject var authVM = AuthViewModel()
        @StateObject var playlistVM = PlaylistBuilderViewModel()
        
        var body: some Scene {
            WindowGroup {
                    MainAppView()
                        .environmentObject(authVM)
                }
            }
        }
