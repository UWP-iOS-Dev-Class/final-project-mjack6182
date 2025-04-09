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
                VStack(spacing: 20) {
                    Text("Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Text("User account details go here")
                        .padding()
                    Spacer()
                }
                .navigationTitle("Account")
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Account")
            }
            .tag(2)
        }
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
    }
}
