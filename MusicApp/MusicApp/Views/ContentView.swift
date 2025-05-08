//
//  ContentView.swift
//  MusicApp
//
//  Created by Jack Miller on 4/7/25.

import SwiftUI

struct ContentView: View {
    @State private var selectedPlaylistType: PlaylistType? = nil
    @State private var playlistName: String = ""
    @State private var selectedTab = 0
    @StateObject private var playlistVM = PlaylistBuilderViewModel()
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTabView(
                selectedPlaylistType: $selectedPlaylistType,
                playlistName: $playlistName,
                playlistVM: playlistVM
            )
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)

            NavigationView {
                MyPlaylistsView(playlists: $playlistVM.myPlaylists)
                    .navigationTitle("My Playlists")
            }
            .tabItem {
                Image(systemName: "music.note.list")
                Text("My Playlists")
            }
            .tag(1)

            AccountTabView(authVM: authVM)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Account")
                }
                .tag(2)
        }
    }
}
