//
//  SongRecommendationView.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.

import SwiftUI

struct SongRecommendationView: View {
    let playlistType: PlaylistType
    let playlistName: String
    
    // For demo purposes, we use some mock songs.
    @State private var songs: [Song] = [
        Song(id: "1", title: "Song One", artist: "Artist A", artworkURL: ""),
        Song(id: "2", title: "Song Two", artist: "Artist B", artworkURL: ""),
        Song(id: "3", title: "Song Three", artist: "Artist C", artworkURL: "")
    ]
    
    var currentSong: Song? {
        songs.first
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
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
                    ForEach(songs) { song in
                        SwipeCardView(
                            song: song,
                            onSwipeLeft: {
                                // Add the song to your playlist.
                                print("Added \(song.title) to playlist")
                                removeSong(song)
                            },
                            onSwipeRight: {
                                // Skip the song.
                                print("Skipped \(song.title)")
                                removeSong(song)
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
    
    private func removeSong(_ song: Song) {
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            songs.remove(at: index)
        }
    }
}

struct SongRecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        SongRecommendationView(playlistType: .chill, playlistName: "Chill Vibes")
    }
}
