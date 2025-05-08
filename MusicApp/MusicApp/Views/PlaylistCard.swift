//
//  PlaylistCard.swift
//  MusicApp
//
//  Created by Jack Miller on 5/7/25.
//

import SwiftUI

struct PlaylistCard: View {
    let playlist: Playlist

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorForPlaylistType(playlist.type))
                    .frame(width: 60, height: 60)

                Image(systemName: iconForPlaylistType(playlist.type))
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(playlist.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(.primary)

                Text(playlist.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    public func colorForPlaylistType(_ type: PlaylistType) -> Color {
        switch type {
        case .chill: return .blue
        case .workout: return .red
        case .focus: return .purple
        case .party: return .green
        case .hipHop: return .black
        case .rap: return .gray
        case .pop: return .red
        case .rock: return .blue
        case .emoRap: return .white
        }
    }

    public func iconForPlaylistType(_ type: PlaylistType) -> String {
        switch type {
        case .chill: return "cloud.sun"
        case .workout: return "flame"
        case .focus: return "brain.head.profile"
        default: return "music.note.house"
        }
    }
}
