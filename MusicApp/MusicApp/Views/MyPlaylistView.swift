//
//  MyPlaylistView.swift
//  MusicApp
//
//  Created by Jack Miller on 5/7/25.
//

import SwiftUI

struct MyPlaylistsView: View {
    @Binding var playlists: [Playlist]

    var body: some View {
        if playlists.isEmpty {
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
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(playlists) { playlist in
                        NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
                            PlaylistCard(playlist: playlist)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deletePlaylist(playlist)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
    private func deletePlaylist(_ playlist: Playlist) {
        if let index = playlists.firstIndex(where: { $0.id == playlist.id }) {
            playlists.remove(at: index)
        }
    }
}

