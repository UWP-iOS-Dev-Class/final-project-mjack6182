//
//  AuthviewModel.swift
//  MusicApp
//
//  Created by Jack Miller on 4/30/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var db = FirebaseManager.shared.firestore
    private var auth = FirebaseManager.shared.auth
    
    init() {
        listenToAuthState()
    }
    
    func listenToAuthState() {
        auth.addStateDidChangeListener { [weak self] _, user in
            self?.userSession = user
            if let user = user {
                print("User is logged in: \(user.uid)")
                self?.fetchUserData(uid: user.uid)
            } else {
                print("User is not logged in.")
            }
        }
    }
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Login failed: \(error.localizedDescription)"
                } else {
                    self?.userSession = result?.user
                    if let uid = result?.user.uid {
                        self?.fetchUserData(uid: uid)
                    }
                }
            }
        }
    }
    
    func logout() {
        do {
            try auth.signOut()
            self.userSession = nil
        } catch {
            self.errorMessage = "Failed to sign out: \(error.localizedDescription)"
        }
    }
    
    private func fetchUserData(uid: String) {
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                print("Fetched user data: \(String(describing: data))")
            } else {
                print("No user document found for uid: \(uid)")
            }
        }
    }
}
