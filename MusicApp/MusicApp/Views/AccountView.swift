//
//  AccountView.swift
//  MusicApp
//
//  Created by Jack Miller on 5/7/25.
//

import SwiftUI

struct AccountTabView: View {
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    VStack(spacing: 15) {
                        AccountOptionButton(title: "Edit Profile", iconName: "person.fill") {}
                        AccountOptionButton(title: "Settings", iconName: "gear") {}
                        AccountOptionButton(title: "Help & Support", iconName: "questionmark.circle") {}
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Spacer()

                    Button(action: {
                        authVM.logout()
                    }) {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 30)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct AccountOptionButton: View {
    var title: String
    var iconName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName).frame(width: 30)
                Text(title).font(.headline)
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
