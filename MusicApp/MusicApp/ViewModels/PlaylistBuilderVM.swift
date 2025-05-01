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
    
    // Key for storing playlists in UserDefaults
    private let playlistsStorageKey = "user_playlists"
    
    init() {
        loadPlaylists()
    }
    
    // Adds a new playlist if it doesn't already exist
    func addPlaylist(_ playlist: Playlist) {
        if !myPlaylists.contains(where: { $0.id == playlist.id }) {
            myPlaylists.append(playlist)
            savePlaylists()
        }
    }
    
    // Saves all playlists to UserDefaults
    func savePlaylists() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(myPlaylists)
            UserDefaults.standard.set(data, forKey: playlistsStorageKey)
        } catch {
            print("Failed to save playlists: \(error.localizedDescription)")
        }
    }
    
    // Loads playlists from UserDefaults
    func loadPlaylists() {
        if let data = UserDefaults.standard.data(forKey: playlistsStorageKey) {
            do {
                let decoder = JSONDecoder()
                myPlaylists = try decoder.decode([Playlist].self, from: data)
            } catch {
                print("Failed to load playlists: \(error.localizedDescription)")
            }
        }
    }
    
    // Removes a playlist
    func removePlaylist(_ playlist: Playlist) {
        myPlaylists.removeAll { $0.id == playlist.id }
        savePlaylists()
    }
    
    // Updates a playlist (e.g., when songs are added)
    func updatePlaylist(_ playlist: Playlist) {
        if let index = myPlaylists.firstIndex(where: { $0.id == playlist.id }) {
            myPlaylists[index] = playlist
            savePlaylists()
        }
    }
    
    // Optional: Add any additional helper functions needed for playlist management.
}
