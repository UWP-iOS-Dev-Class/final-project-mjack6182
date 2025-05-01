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
    case hipHop = "HipHop"
    case rap = "Rap"
    case pop = "Pop"
    case rock = "Rock"
    case emoRap = "Emo Rap"
    }
