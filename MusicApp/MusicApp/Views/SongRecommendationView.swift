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
                                    // Add the song to your playlist.
                                    print("Added \(song.title) to playlist")
                                    viewModel.removeSong(song)
                                },
                                onSwipeRight: {
                                    // Skip the song.
                                    print("Skipped \(song.title)")
                                    viewModel.removeSong(song)
                                }
                            )
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("\(playlistType.rawValue) Playlist")
            }
        }
    }
}

struct SongRecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        SongRecommendationView(playlistType: .chill, playlistName: "Chill Vibes")
    }
}
