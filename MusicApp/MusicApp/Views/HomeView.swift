//
//  HomeView.swift
//  MusicApp
//
//  Created by Jack Miller on 5/6/25.
//

import SwiftUI

struct HomeTabView: View {
    @Binding var selectedPlaylistType: PlaylistType?
    @Binding var playlistName: String
    var playlistVM: PlaylistBuilderViewModel

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Text("Playlist Builder")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .padding()

                    Spacer()

                    VStack(spacing: 20) {
                        TextField("Enter Playlist Name", text: $playlistName)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .padding(.horizontal)

                        NavigationLink(
                            destination: PlaylistSelectionView(selectedPlaylistType: $selectedPlaylistType),
                            label: {
                                Text("Select Playlist Type")
                                    .font(.title3)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                        )

                        if let playlistType = selectedPlaylistType {
                            NavigationLink(
                                destination: PlaylistCreationWrapperView(playlistType: playlistType, playlistName: playlistName, playlistVM: playlistVM),
                                label: {
                                    Text("Create \(playlistName.isEmpty ? playlistType.rawValue : playlistName) Playlist")
                                        .font(.title3)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                }
                            )
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                    .shadow(radius: 10)

                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}
