//
//  User.swift
//  MusicApp
//
//  Created by Jack Miller on 4/30/25.
//

struct User: Identifiable, Codable, Hashable {
    let id: String
    var firstName: String
    var lastName: String
    var email: String
}
