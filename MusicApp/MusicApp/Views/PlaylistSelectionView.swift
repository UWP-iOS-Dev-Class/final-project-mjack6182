//
//  PlaylistSelectionView.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import SwiftUI

struct PlaylistSelectionView: View {
    @Binding var selectedPlaylistType: PlaylistType?
    
    var body: some View {
        List(PlaylistType.allCases) { type in
            Button(action: {
                selectedPlaylistType = type
            }) {
                Text(type.rawValue)
                    .padding()
            }
        }
        .navigationTitle("Select Playlist Type")
    }
}

struct PlaylistSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistSelectionView(selectedPlaylistType: .constant(nil))
    }
}
