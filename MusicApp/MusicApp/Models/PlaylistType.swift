//
//  PlaylistType.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import Foundation

enum PlaylistType: String, CaseIterable, Identifiable, Codable {
    var id: String { rawValue }
    
    case chill = "Chill"
    case workout = "Workout"
    case focus = "Focus"
    case party = "Party"
    // Add additional playlist types as needed.
}
