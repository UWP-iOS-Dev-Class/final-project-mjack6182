# Final_Project
# 🎵 MusicApp

**MusicApp** is a SwiftUI application that allows users to easily create and manage custom music playlists with a personalized experience. The app features user authentication via Firebase, personalized playlist creation, and a sleek, modern interface designed for simplicity and ease of use.

## 🚀 Features


- **User Authentication**  
  Users can log in, and securely authenticate using Firebase Authentication. Session persistence keeps users logged in across app launches.

- **Playlist Builder**  
  - Create playlists by selecting a name and a playlist type (chill, workout, focus, party, etc.).
  - Easy navigation to select playlist types and begin building playlists.
  - Playlists are organized and displayed on the **My Playlists** tab.

- **Song Recommendations**  
  Users can receive song recommendations based on the playlist type and can swipe to add or skip songs .

- **Persistent Data**  
  User data are stored and fetched using Firebase Firestore.

## 📱 Screens and Views

- **OnboardingView**: Multi-page introduction to the app.
- **LoginView**: User login with email/password.
- **ContentView**: Tabbed interface containing Home, My Playlists, and Account tabs.
- **HomeTabView**: Playlist creation interface.
- **MyPlaylistsView**: Displays user's playlists and allows deletion.
- **PlaylistDetailView**: Shows detailed playlist info and songs.
- **AccountTabView**: Account options and sign-out functionality.

## 🔐 Authentication Flow

- Users log in.
- After authentication, user sessions are preserved.
- Firestore stores additional user data under the `users` collection.
- If a user document does not exist, a new one can be created upon signup (optional future enhancement).

## Future Features I would want to complete

- I want to introduce the spotify and apple music sdks for better song recommendations because the itunes is not very up to date.
- I want to add so the users can play snippets of the music
- More account customization
- edit and modfiy existing playlists
