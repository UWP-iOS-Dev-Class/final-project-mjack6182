//
//  PlaylistDetailView.swift
//  MusicApp
//
//  Created by Jack Miller on 5/7/25.
//

import SwiftUI

struct PlaylistDetailView: View {
    @ObservedObject var playlist: Playlist
    @EnvironmentObject private var playlistVM: PlaylistBuilderViewModel

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [colorForPlaylistType(playlist.type).opacity(0.8), .black]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 15) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colorForPlaylistType(playlist.type))
                            .frame(width: 100, height: 100)

                        Image(systemName: iconForPlaylistType(playlist.type))
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading) {
                        Text(playlist.name)
                            .font(.title).bold().foregroundColor(.white)
                        Text(playlist.type.rawValue)
                            .foregroundColor(.white.opacity(0.8))
                        Text("\(playlist.songs.count) songs")
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal)

                if playlist.songs.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "music.note")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.6))
                        Text("No Songs Yet")
                            .foregroundColor(.white.opacity(0.8))
                        Text("Return to Home and swipe left on songs to add them.")
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 50)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(playlist.songs) { song in
                                SongRow(song: song)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding(.top)
        }
        .navigationBarTitle("", displayMode: .inline)
    }

    private func colorForPlaylistType(_ type: PlaylistType) -> Color {
        PlaylistCard(playlist: playlist).colorForPlaylistType(type)
    }

    private func iconForPlaylistType(_ type: PlaylistType) -> String {
        PlaylistCard(playlist: playlist).iconForPlaylistType(type)
    }
}
