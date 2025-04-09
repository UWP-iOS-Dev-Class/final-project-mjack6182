//
//  PlaylistBuilderVM.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import SwiftUI
import Combine

class PlaylistBuilderViewModel: ObservableObject {
    // The currently selected playlist type
    @Published var selectedPlaylistType: PlaylistType? = nil
    
    // The name entered for the new playlist
    @Published var playlistName: String = ""
    
    // The list of playlists created by the user
    @Published var myPlaylists: [Playlist] = []
    
    // Adds a new playlist if it doesn't already exist
    func addPlaylist(_ playlist: Playlist) {
        if !myPlaylists.contains(where: { $0.id == playlist.id }) {
            myPlaylists.append(playlist)
        }
    }
    
    // Optional: Add any additional helper functions needed for playlist management.
}
