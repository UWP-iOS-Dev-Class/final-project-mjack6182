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
                // Use AsyncImage to load the artwork from URL
                AsyncImage(url: URL(string: song.artworkURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 250, height: 250)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 250)
                            .cornerRadius(10)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 250, height: 250)
                            .cornerRadius(10)
                            .overlay(
                                Text("Failed to load")
                                    .foregroundColor(.white)
                            )
                    @unknown default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 250, height: 250)
                            .cornerRadius(10)
                    }
                }
                
                Text(song.title)
                    .font(.headline)
                    .padding(.top, 10)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(song.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            .padding()
            .frame(width: 300, height: 400)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .offset(x: offset.width, y: 0)
            // Add visual cues for swiping with rotation and opacity
            .rotationEffect(.degrees(Double(offset.width) * 0.05))
            .opacity(2 - Double(abs(offset.width)) / 100)
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
                        } else {
                            // Reset if not swiped far enough
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        }
                    }
            )
            .animation(.spring(), value: offset)
            
            // Add swipe direction indicators
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.green)
                    .opacity(offset.width < -20 ? Double(-offset.width) / 100 : 0)
                    .font(.system(size: 100))
                    .padding(.leading, 40)
                
                Spacer()
                
                Image(systemName: "x.circle.fill")
                    .foregroundColor(.red)
                    .opacity(offset.width > 20 ? Double(offset.width) / 100 : 0)
                    .font(.system(size: 100))
                    .padding(.trailing, 40)
            }
        }
    }
}

struct SwipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCardView(
            song: Song(id: "1", title: "Demo Song", artist: "Demo Artist", artworkURL: "https://via.placeholder.com/250"),
            onSwipeLeft: { print("Swiped left!") },
            onSwipeRight: { print("Swiped right!") }
        )
    }
}
