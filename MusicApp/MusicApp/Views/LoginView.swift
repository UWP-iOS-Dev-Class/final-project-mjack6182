import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // App logo or name
                Text("MusicApp")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                // Authentication form
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                    
                    Button(action: {
                        if isSignUp {
                            authVM.signUp(email: email, password: password) { success, message in
                                if !success {
                                    alertMessage = message ?? "Error signing up"
                                    showAlert = true
                                }
                            }
                        } else {
                            authVM.signIn(email: email, password: password) { success, message in
                                if !success {
                                    alertMessage = message ?? "Error signing in"
                                    showAlert = true
                                }
                            }
                        }
                    }) {
                        Text(isSignUp ? "Sign Up" : "Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(email.isEmpty || password.isEmpty || authVM.isLoading)
                    .opacity(email.isEmpty || password.isEmpty || authVM.isLoading ? 0.6 : 1)
                    
                    if authVM.isLoading {
                        ProgressView()
                    }
                }
                .padding(.horizontal, 32)
                
                // Switch between sign in/sign up
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .foregroundColor(.white)
                        .underline()
                }
                .padding(.top, 10)
                
                // "OR" divider
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text("OR")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .padding(.horizontal, 8)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                
                // Sign in with Apple option
                Button(action: {
                    authVM.signInWithApple()
                }) {
                    HStack {
                        Image(systemName: "apple.logo")
                            .font(.title2)
                        Text("Sign in with Apple")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .padding(.top, 60)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Authentication Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
} 