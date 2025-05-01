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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // The criteria for recommendations
    var playlistType: PlaylistType
    var playlistName: String
    
    init(playlistType: PlaylistType, playlistName: String) {
        self.playlistType = playlistType
        self.playlistName = playlistName
        Task {
            await fetchSongs()
        }
    }
    
    // Fetch recommended songs based on the selected playlist type
    @MainActor
    func fetchSongs() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Map the playlist type to appropriate search terms for the API
            let searchTerm: String
            switch playlistType {
            case .chill:
                searchTerm = "chill lofi"
            case .workout:
                searchTerm = "workout gym"
            case .party:
                searchTerm = "party dance"
            case .focus:
                searchTerm = "focus concentration"
            case .hipHop:
                searchTerm = "hip hop"
            case .rap:
                searchTerm = "rap"
            case .rock:
                searchTerm = "rock"
            case .pop:
                searchTerm = "pop"
            case .emoRap:
                searchTerm = "emo rap"
            }
            
            // Use our API service to fetch songs
            let fetchedSongs = try await MusicAPIService.shared.getRecommendedSongs(for: searchTerm)
            self.songs = fetchedSongs
        } catch let error as APIError {
            switch error {
            case .invalidURL:
                errorMessage = "Invalid URL"
            case .invalidResponse:
                errorMessage = "Invalid response from server"
            case .decodingError(let message):
                errorMessage = "Error decoding data: \(message)"
            }
        } catch {
            errorMessage = "Unknown error: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // Remove a song from the recommendation queue
    func removeSong(_ song: Song) {
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            songs.remove(at: index)
        }
    }
}
