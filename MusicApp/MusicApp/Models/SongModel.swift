//
//  SongModel.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import Foundation

struct Song: Identifiable, Codable {
    let id: String
    let title: String
    let artist: String
    let artworkURL: String
}
