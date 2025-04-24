//  AuthViewModel.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import SwiftUI
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class AuthViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @Published var user: User? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    private var currentNonce: String?
 
    override init() {
        self.user = Auth.auth().currentUser
        super.init()
        
        // Add a listener for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.user = user
            }
        }
    }
    
    // MARK: - Email/Password Authentication
    
    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    let errorMessage = self?.handleAuthError(error)
                    completion(false, errorMessage)
                } else {
                    self?.user = authResult?.user
                    completion(true, nil)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    let errorMessage = self?.handleAuthError(error)
                    completion(false, errorMessage)
                } else {
                    self?.user = authResult?.user
                    completion(true, nil)
                }
            }
        }
    }
    
    // Helper method to handle various Firebase Auth errors
    private func handleAuthError(_ error: Error) -> String {
        let errorCode = (error as NSError).code
        switch errorCode {
        case AuthErrorCode.wrongPassword.rawValue:
            return "Invalid password. Please try again."
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email format."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Email already in use."
        case AuthErrorCode.weakPassword.rawValue:
            return "Password is too weak. It must be at least 6 characters."
        case AuthErrorCode.userNotFound.rawValue:
            return "User not found. Please check your email or sign up."
        case AuthErrorCode.networkError.rawValue:
            return "Network error. Please try again later."
        default:
            return error.localizedDescription
        }
    }
    
    // MARK: - Anonymous Authentication
    
    /// Sign in the user anonymously. Replace or extend this for different sign-in methods.
    func signInAnonymously() {
        isLoading = true
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.user = authResult?.user
                }
            }
        }
    }
    
    // MARK: - Apple Authentication
    
    func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    print("Error authenticating: \(error.localizedDescription)")
                    return
                }
                self?.user = authResult?.user
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple error: \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window
        }
        return UIWindow()
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Helper Methods
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with error \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}
