//
//  FirebaseManager.swift
//  MusicApp
//
//  Created by Jack Miller on 5/6/25.
//

// MusicApp/Models/FirebaseManager.swift
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
// import FirebaseAppCheck // Only if you use AppCheck directly in this manager

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()

    let auth: Auth
    let firestore: Firestore

    private init() {
        // FirebaseApp.configure() // REMOVE THIS - It's in AppDelegate
        // AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory()) // REMOVE THIS - It's in AppDelegate
        // UserDefaults.standard.set(true, forKey: "FirebaseAppCheckDebugTokenKey") // REMOVE THIS - It's in AppDelegate and deprecated approach

        // These initializations are fine as long as FirebaseApp.configure() has been called first.
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
    }
}
