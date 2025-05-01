//
//  RegisterView.swift
//  MusicApp
//
//  Created by Jack Miller on 4/30/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: register) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top)

                Spacer()
            }
            .padding()
            .navigationTitle("Register")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Registration Failed"),
                      message: Text(authViewModel.errorMessage ?? "Unknown error"),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func register() {
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty else {
            authViewModel.errorMessage = "Please fill in all fields."
            showingAlert = true
            return
        }
        
        guard password == confirmPassword else {
            authViewModel.errorMessage = "Passwords do not match."
            showingAlert = true
            return
        }
        
        authViewModel.signUp(firstName: firstName,
                             lastName: lastName,
                             email: email,
                             password: password) { success in
            if !success {
                showingAlert = true
            }
        }
    }
}
