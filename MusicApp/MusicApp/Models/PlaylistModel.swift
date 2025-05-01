//
//  PlaylistModel.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import Foundation

class Playlist: Identifiable, ObservableObject, Codable {
    let id: UUID
    var name: String
    var type: PlaylistType
    @Published var songs: [Song] = []
    
    init(name: String, type: PlaylistType) {
        self.id = UUID()
        self.name = name
        self.type = type
    }
    
    // Codable conformance
    enum CodingKeys: String, CodingKey {
        case id, name, type, songs
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(PlaylistType.self, forKey: .type)
        songs = try container.decode([Song].self, forKey: .songs)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(songs, forKey: .songs)
    }
}
