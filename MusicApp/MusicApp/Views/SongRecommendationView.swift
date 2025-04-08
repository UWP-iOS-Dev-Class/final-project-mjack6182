//
//  SongRecommendationView.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import SwiftUI

struct SongRecommendationView: View {
    let playlistType: PlaylistType
    
    // For demo purposes, we use some mock songs.
    @State private var songs: [Song] = [
        Song(id: "1", title: "Song One", artist: "Artist A", artworkURL: ""),
        Song(id: "2", title: "Song Two", artist: "Artist B", artworkURL: ""),
        Song(id: "3", title: "Song Three", artist: "Artist C", artworkURL: "")
    ]
    
    var body: some View {
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
        .padding()
        .navigationTitle("\(playlistType.rawValue) Playlist")
    }
    
    private func removeSong(_ song: Song) {
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            songs.remove(at: index)
        }
    }
}

struct SongRecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        SongRecommendationView(playlistType: .chill)
    }
}
