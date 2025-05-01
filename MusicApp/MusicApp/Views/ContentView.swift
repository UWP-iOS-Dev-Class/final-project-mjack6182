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
    @StateObject private var playlistVM = PlaylistBuilderViewModel()
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
                                    destination: PlaylistCreationWrapperView(playlistType: playlistType, playlistName: playlistName, playlistVM: playlistVM),
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
                MyPlaylistsView(playlists: playlistVM.myPlaylists)
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
                            
//                            if let user = authVM.user {
//                                Text(user.email ?? "No email")
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                                
//                                Text("User ID: \(user.uid.prefix(8))...")
//                                    .font(.caption)
//                                    .foregroundColor(.white.opacity(0.8))
//                            }
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
        if playlists.isEmpty {
            // Empty state view
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "music.note.list")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                
                Text("No Playlists Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Create your first playlist in the Home tab")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
        } else {
            // Playlist list view
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(playlists) { playlist in
                        NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
                            PlaylistCard(playlist: playlist)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

// Card view for individual playlists
struct PlaylistCard: View {
    let playlist: Playlist
    
    var body: some View {
        HStack(spacing: 15) {
            // Playlist icon based on type
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorForPlaylistType(playlist.type))
                    .frame(width: 60, height: 60)
                
                Image(systemName: iconForPlaylistType(playlist.type))
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(playlist.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                Text(playlist.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // Helper function to get color based on playlist type
    private func colorForPlaylistType(_ type: PlaylistType) -> Color {
        switch type {
        case .chill:
            return Color.blue
        case .workout:
            return Color.red
        case .focus:
            return Color.purple
        case .party:
            return Color.green
        case .hipHop:
            return Color.black
        case .rap:
            return Color.gray
        case .pop:
            return Color.red
        case .rock:
            return Color.blue
        case .emoRap:
            return Color.white
        }
        }
    }
    
    // Helper function to get icon based on playlist type
    private func iconForPlaylistType(_ type: PlaylistType) -> String {
        switch type {
        case .chill:
            return "cloud.sun"
        case .workout:
            return "flame"
        case .focus:
            return "brain.head.profile"
        case .party:
            return "music.note.house"
        case .hipHop:
            return "music.note.house"
        case .rap:
            return "music.note.house"
        case .pop:
            return "music.note.house"
        case .rock:
            return "music.note.house"
        case .emoRap:
            return "music.note.house"
        }
    }


// Detail view for a specific playlist
struct PlaylistDetailView: View {
    @ObservedObject var playlist: Playlist
    @EnvironmentObject private var playlistVM: PlaylistBuilderViewModel
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [colorForPlaylistType(playlist.type).opacity(0.8), Color.black]),
                          startPoint: .top,
                          endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // Playlist header
                HStack(spacing: 15) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colorForPlaylistType(playlist.type))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: iconForPlaylistType(playlist.type))
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(playlist.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(playlist.type.rawValue)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("\(playlist.songs.count) songs")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal)
                
                // Action buttons
                HStack(spacing: 20) {
                    Button(action: {
                        // Play action
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Play")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    
                    Button(action: {
                        // Shuffle action
                    }) {
                        HStack {
                            Image(systemName: "shuffle")
                            Text("Shuffle")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                
                // Song list header
                HStack {
                    Text("Songs")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Song list
                if playlist.songs.isEmpty {
                    // Empty state
                    VStack(spacing: 15) {
                        Image(systemName: "music.note")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("No Songs Yet")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Return to Home and swipe left on songs to add them to this playlist")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 50)
                } else {
                    // Song list with actual songs
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(playlist.songs) { song in
                                SongRow(song: song)
                            }
                        }
                        .background(Color(.systemBackground).opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding(.top)
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    // Helper function to get color based on playlist type
    private func colorForPlaylistType(_ type: PlaylistType) -> Color {
        switch type {
        case .chill:
            return Color.blue
        case .workout:
            return Color.red
        case .focus:
            return Color.purple
        case .party:
            return Color.green
        case .hipHop:
            return Color.black
        case .rap:
            return Color.gray
        case .pop:
            return Color.red
        case .rock:
            return Color.blue
        case .emoRap:
            return Color.white
        }
    }
    
    // Helper function to get icon based on playlist type
    private func iconForPlaylistType(_ type: PlaylistType) -> String {
        switch type {
        case .chill:
            return "cloud.sun"
        case .workout:
            return "flame"
        case .focus:
            return "brain.head.profile"
        case .party:
            return "music.note.house"
        case .hipHop:
            return "music.note.house"
        case .rap:
            return "music.note.house"
        case .pop:
            return "music.note.house"
        case .rock:
            return "music.note.house"
        case .emoRap:
            return "music.note.house"

        }
    }
}

// Song row component
struct SongRow: View {
    let song: Song
    
    var body: some View {
        HStack(spacing: 15) {
            // Song artwork placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "music.note")
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(song.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(song.artist)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: {
                // Song options
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 15)
    }
}

// Wrapper view that creates the playlist when SongRecommendationView appears
struct PlaylistCreationWrapperView: View {
    let playlistType: PlaylistType
    let playlistName: String
    let playlistVM: PlaylistBuilderViewModel
    @State private var didCreate = false
    
    var body: some View {
        SongRecommendationView(playlistType: playlistType, playlistName: playlistName)
            .environmentObject(playlistVM)
            .onAppear {
                if !didCreate {
                    let newPlaylist = Playlist(name: playlistName.isEmpty ? playlistType.rawValue : playlistName, type: playlistType)
                    playlistVM.addPlaylist(newPlaylist)
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
