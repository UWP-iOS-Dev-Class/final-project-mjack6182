//
//  SongRecommendationVM.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import SwiftUI
import Combine

class SongRecommendationViewModel: ObservableObject {
    // The list of recommended songs
    @Published var songs: [Song] = []
    
    // The criteria for recommendations
    var playlistType: PlaylistType
    var playlistName: String
    
    init(playlistType: PlaylistType, playlistName: String) {
        self.playlistType = playlistType
        self.playlistName = playlistName
        fetchSongs()
    }
    
    // Fetch recommended songs based on the selected playlist type (and maybe playlistName)
    func fetchSongs() {
        // Replace with your actual music fetching logic.
        // Here we add some mock songs for demonstration purposes.
        self.songs = [
            Song(id: "1", title: "Song One", artist: "Artist A", artworkURL: ""),
            Song(id: "2", title: "Song Two", artist: "Artist B", artworkURL: ""),
            Song(id: "3", title: "Song Three", artist: "Artist C", artworkURL: "")
        ]
    }
    
    // Optional: Functionality to handle swipe actions, etc., can be added here.
}
