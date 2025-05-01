import Foundation

class MusicAPIService {
    static let shared = MusicAPIService()
    
    private let baseURL = "https://itunes.apple.com/search"
    
    private init() {}
    
    func searchSongs(for term: String, limit: Int = 20) async throws -> [Song] {
        guard var components = URLComponents(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
            return searchResponse.results.map { result in
                Song(
                    id: result.trackId,
                    title: result.trackName,
                    artist: result.artistName,
                    artworkURL: result.artworkUrl100
                )
            }
        } catch {
            throw APIError.decodingError(error.localizedDescription)
        }
    }
    
    func getRecommendedSongs(for genre: String, limit: Int = 20) async throws -> [Song] {
        // In a real app, this would be a separate endpoint for recommendations
        // For now, we'll use the search API with the genre as the search term
        return try await searchSongs(for: genre, limit: limit)
    }

}

// Response models for the iTunes API
struct SearchResponse: Codable {
    let resultCount: Int
    let results: [TrackResult]
}

struct TrackResult: Codable {
    let trackId: String
    let trackName: String
    let artistName: String
    let artworkUrl100: String
    
    enum CodingKeys: String, CodingKey {
        case trackId
        case trackName
        case artistName
        case artworkUrl100
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle possible Int or String trackId by converting to String
        if let intTrackId = try? container.decode(Int.self, forKey: .trackId) {
            trackId = String(intTrackId)
        } else {
            trackId = try container.decode(String.self, forKey: .trackId)
        }
        
        trackName = try container.decode(String.self, forKey: .trackName)
        artistName = try container.decode(String.self, forKey: .artistName)
        artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(String)
}

