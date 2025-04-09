//
//  SwipeCardView.swift
//  MusicApp
//
//  Created by Jack Miller on 4/8/25.
//

import SwiftUI

struct SwipeCardView: View {
    var song: Song
    var onSwipeLeft: () -> Void
    var onSwipeRight: () -> Void
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            VStack {
                // Replace with an asynchronous image loader if needed.
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 250, height: 250)
                    .cornerRadius(10)
                    .overlay(
                        Text("Artwork")
                            .foregroundColor(.white)
                    )
                Text(song.title)
                    .font(.headline)
                    .padding(.top, 10)
                Text(song.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(width: 300, height: 400)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .offset(x: offset.width, y: 0)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        if offset.width < -100 {
                            // Swipe left → Add to playlist.
                            onSwipeLeft()
                        } else if offset.width > 100 {
                            // Swipe right → Skip song.
                            onSwipeRight()
                        }
                        offset = .zero
                    }
            )
            .animation(.spring(), value: offset)
        }
    }
}

struct SwipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCardView(
            song: Song(id: "1", title: "Demo Song", artist: "Demo Artist", artworkURL: ""),
            onSwipeLeft: { print("Swiped left!") },
            onSwipeRight: { print("Swiped right!") }
        )
    }
}
