//
//  SongRecommendationView.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.

import SwiftUI

struct SongRecommendationView: View {
    let playlistType: PlaylistType
    let playlistName: String
    
    @StateObject private var viewModel: SongRecommendationViewModel
    @EnvironmentObject private var playlistVM: PlaylistBuilderViewModel
    @State private var showToast = false
    @State private var toastMessage = ""
    
    init(playlistType: PlaylistType, playlistName: String) {
        self.playlistType = playlistType
        self.playlistName = playlistName
        self._viewModel = StateObject(wrappedValue: SongRecommendationViewModel(playlistType: playlistType, playlistName: playlistName))
    }
    
    var currentSong: Song? {
        viewModel.songs.first
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                VStack {
                    Text("Loading songs...")
                    ProgressView()
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("Error")
                        .font(.headline)
                    Text(errorMessage)
                    Button("Try Again") {
                        Task {
                            await viewModel.fetchSongs()
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
            } else if viewModel.songs.isEmpty {
                VStack {
                    Text("No songs available")
                        .font(.headline)
                    Button("Try Again") {
                        Task {
                            await viewModel.fetchSongs()
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
            } else {
                VStack {
                    // Header view: displays the playlist title and current song name
                    VStack(spacing: 4) {
                        Text(playlistName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        if let currentSong = currentSong {
                            Text("Now Playing: \(currentSong.title)")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        } else {
                            Text("No song playing")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Swipeable cards view
                    ZStack {
                        ForEach(viewModel.songs) { song in
                            SwipeCardView(
                                song: song,
                                onSwipeLeft: {
                                    // Add the song to the playlist
                                    addSongToPlaylist(song)
                                    viewModel.removeSong(song)
                                },
                                onSwipeRight: {
                                    // Skip the song
                                    print("Skipped \(song.title)")
                                    viewModel.removeSong(song)
                                }
                            )
                        }
                    }
                    
                    // Hint text
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Swipe left to add to playlist")
                        }
                        .foregroundColor(.white)
                        
                        HStack {
                            Text("Swipe right to skip")
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("\(playlistType.rawValue) Playlist")
            }
            
            // Toast notification
            if showToast {
                VStack {
                    Spacer()
                    Text(toastMessage)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom))
                }
                .animation(.easeInOut, value: showToast)
                .zIndex(1)
            }
        }
    }
    
    // Function to add a song to the current playlist
    private func addSongToPlaylist(_ song: Song) {
        // Find the playlist with matching name and type
        if let index = playlistVM.myPlaylists.firstIndex(where: { 
            $0.name == (playlistName.isEmpty ? playlistType.rawValue : playlistName) && 
            $0.type == playlistType 
        }) {
            // Add the song if it's not already in the playlist
            if !playlistVM.myPlaylists[index].songs.contains(where: { $0.id == song.id }) {
                playlistVM.myPlaylists[index].songs.append(song)
                playlistVM.updatePlaylist(playlistVM.myPlaylists[index])
                
                // Show toast notification
                toastMessage = "Added '\(song.title)' to playlist"
                showToast = true
                
                // Hide toast after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showToast = false
                    }
                }
            }
        }
    }
}

struct SongRecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        SongRecommendationView(playlistType: .chill, playlistName: "Chill Vibes")
    }
}
