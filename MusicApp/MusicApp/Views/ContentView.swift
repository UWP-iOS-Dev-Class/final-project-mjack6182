//
//  ContentView.swift
//  MusicApp
//
//  Created by Jack Miller on 4/7/25.

import SwiftUI


struct ContentView: View {
    @State private var selectedPlaylistType: PlaylistType? = nil
    @State private var playlistName: String = ""
    @State private var selectedTab = 0
    @State private var myPlaylists: [Playlist] = []
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationView {
                ZStack {
                    // Background gradient
                    LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        // Header Title
                        Text("Playlist Builder")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                        
                        // Central card containing input and navigation links
                        VStack(spacing: 20) {
                            TextField("Enter Playlist Name", text: $playlistName)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            
                            NavigationLink(
                                destination: PlaylistSelectionView(selectedPlaylistType: $selectedPlaylistType),
                                label: {
                                    Text("Select Playlist Type")
                                        .font(.title3)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                }
                            )
                            
                            if let playlistType = selectedPlaylistType {
                                // NavigationLink wrapped in PlaylistCreationWrapperView to add the created playlist
                                NavigationLink(
                                    destination: PlaylistCreationWrapperView(playlistType: playlistType, playlistName: playlistName, onPlaylistCreated: { newPlaylist in
                                        if !myPlaylists.contains(where: { $0.id == newPlaylist.id }) {
                                            myPlaylists.append(newPlaylist)
                                        }
                                    }),
                                    label: {
                                        Text("Create \(playlistName.isEmpty ? playlistType.rawValue : playlistName) Playlist")
                                            .font(.title3)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .padding(.horizontal)
                                    }
                                )
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            // My Playlists Tab
            NavigationView {
                MyPlaylistsView(playlists: myPlaylists)
                    .navigationTitle("My Playlists")
            }
            .tabItem {
                Image(systemName: "music.note.list")
                Text("My Playlists")
            }
            .tag(1)
            
            // Account Tab
            NavigationView {
                ZStack {
                    // Background gradient
                    LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        // User profile section
                        VStack(spacing: 10) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            
                            if let user = authVM.user {
                                Text(user.email ?? "No email")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("User ID: \(user.uid.prefix(8))...")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Account options
                        VStack(spacing: 15) {
                            AccountOptionButton(title: "Edit Profile", iconName: "person.fill") {
                                // Edit profile action would go here
                            }
                            
                            AccountOptionButton(title: "Settings", iconName: "gear") {
                                // Settings action would go here
                            }
                            
                            AccountOptionButton(title: "Help & Support", iconName: "questionmark.circle") {
                                // Help action would go here
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Sign out button
                        Button(action: {
                            authVM.signOut()
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
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Account")
            }
            .tag(2)
        }
    }
}

// Account option button
struct AccountOptionButton: View {
    var title: String
    var iconName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .frame(width: 30)
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// View to display the list of created playlists
struct MyPlaylistsView: View {
    let playlists: [Playlist]
    
    var body: some View {
        List(playlists) { playlist in
            VStack(alignment: .leading) {
                Text(playlist.name)
                    .font(.headline)
                Text("Type: \(playlist.type.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
}

// Wrapper view that creates the playlist when SongRecommendationView appears
struct PlaylistCreationWrapperView: View {
    let playlistType: PlaylistType
    let playlistName: String
    let onPlaylistCreated: (Playlist) -> Void
    @State private var didCreate = false
    
    var body: some View {
        SongRecommendationView(playlistType: playlistType, playlistName: playlistName)
            .onAppear {
                if !didCreate {
                    let newPlaylist = Playlist(name: playlistName.isEmpty ? playlistType.rawValue : playlistName, type: playlistType)
                    onPlaylistCreated(newPlaylist)
                    didCreate = true
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
