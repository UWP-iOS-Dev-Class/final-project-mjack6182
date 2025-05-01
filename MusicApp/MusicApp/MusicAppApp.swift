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
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
#if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
#endif
        
        return true
    }
    
    @main
    struct MusicAppApp: App {
        @StateObject var authVM = AuthViewModel()
        @StateObject var playlistVM = PlaylistBuilderViewModel()
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
        var body: some Scene {
            WindowGroup {
                    ContentView()
                }
            }
        }
    }
