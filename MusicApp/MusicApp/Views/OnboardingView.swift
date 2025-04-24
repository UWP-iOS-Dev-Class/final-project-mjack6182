//
//  OnboardingView.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showLogin = false
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
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
                    if currentPage < 2 {
                        // Move to next onboarding page if not at the end
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        // Show login screen when onboarding is done
                        showLogin = true
                    }
                }) {
                    Text(currentPage < 2 ? "Next" : "Get Started")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.vertical)
                
                if currentPage < 2 {
                    Button(action: {
                        // Skip to login
                        showLogin = true
                    }) {
                        Text("Skip")
                            .foregroundColor(.white)
                            .underline()
                    }
                    .padding(.bottom)
                }
                
                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
                .environmentObject(authVM)
        }
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
