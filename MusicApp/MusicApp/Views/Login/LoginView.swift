import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: login) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top)
                
                NavigationLink(destination: RegisterView()) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Login")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Login Failed"),
                      message: Text(authViewModel.errorMessage ?? "Unknown error"),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func login() {
        guard !email.isEmpty, !password.isEmpty else {
            authViewModel.errorMessage = "Please fill in all fields."
            showingAlert = true
            return
        }
        
        authViewModel.signIn(email: email, password: password) { success in
            if !success {
                showingAlert = true
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
