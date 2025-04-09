//
//  OnboardingView.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                OnboardingPage(imageName: "Logo",
                               title: "Welcome to MusicApp",
                               subtitle: "Discover new music and build your playlists.")
                .tag(0)
                
                OnboardingPage(imageName: "onboarding2",
                               title: "Personalized Recommendations",
                               subtitle: "Get song suggestions based on your taste.")
                .tag(1)
                
                OnboardingPage(imageName: "onboarding3",
                               title: "Easy Playlist Creation",
                               subtitle: "Build your own playlists with a simple swipe!")
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .padding()
            
            Button(action: {
                Task {
                    await signInUser()
                }
            }, label: {
                if authVM.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Text("Sign in with AppleID")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            })
            .padding(.vertical)
            
            if let error = authVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
    }
    
    private func signInUser() async {
        authVM.signInWithApple()
    }
}

struct OnboardingPage: View {
    var imageName: String
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(AuthViewModel())
    }
}
