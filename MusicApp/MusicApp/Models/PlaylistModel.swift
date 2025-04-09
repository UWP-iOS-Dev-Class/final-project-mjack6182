//
//  PlaylistModel.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import Foundation

class Playlist: Identifiable, ObservableObject {
    let id: UUID
    var name: String
    var type: PlaylistType

    init(name: String, type: PlaylistType) {
        self.id = UUID()
        self.name = name
        self.type = type
    }
}
