//
//  ContentView.swift
//  MusicApp
//
//  Created by Jack Miller on 4/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPlaylistType: PlaylistType? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(
                    destination: PlaylistSelectionView(selectedPlaylistType: $selectedPlaylistType)
                ) {
                    Text("Select Playlist Type")
                        .font(.title2)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if let playlistType = selectedPlaylistType {
                    NavigationLink(
                        destination: SongRecommendationView(playlistType: playlistType)
                    ) {
                        Text("Create \(playlistType.rawValue) Playlist")
                            .font(.title2)
                            .padding()
                            .background(Color.green.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Apple Playlist Builder")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
