//
//  PlaylistCreationWrapperView.swift
//  MusicApp
//
//  Created by Jack Miller on 5/7/25.
//

import SwiftUI

struct PlaylistCreationWrapperView: View {
    let playlistType: PlaylistType
    let playlistName: String
    let playlistVM: PlaylistBuilderViewModel
    @State private var didCreate = false

    var body: some View {
        SongRecommendationView(playlistType: playlistType, playlistName: playlistName)
            .environmentObject(playlistVM)
            .onAppear {
                if !didCreate {
                    let newPlaylist = Playlist(
                        name: playlistName.isEmpty ? playlistType.rawValue : playlistName,
                        type: playlistType
                    )
                    playlistVM.addPlaylist(newPlaylist)
                    didCreate = true
                }
            }
    }
}
