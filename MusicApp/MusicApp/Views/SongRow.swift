//
//  SongRow.swift
//  MusicApp
//
//  Created by Jack Miller on 5/7/25.
//

import SwiftUI

struct SongRow: View {
    let song: Song

    var body: some View {
        HStack(spacing: 15) {
            ZStack {

                Image(systemName: "music.note")
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading) {
                Text(song.title)
                    .foregroundColor(.white)
                Text(song.artist)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Button(action: {
                // Song options here
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.vertical, 8)
    }
}
