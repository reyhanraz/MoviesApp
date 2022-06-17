//
//  Movie.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation

struct Movie: Codable, Equatable {
    let id: Int
    let overview: String
    let posterPath: URL
    let releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    init(id: Int, overview: String, posterPath: URL, releaseDate: String, title: String, video: Bool, voteAverage: Double, voteCount: Int){
        self.id = id
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        overview = try container.decode(String.self, forKey: .overview)
        title = try container.decode(String.self, forKey: .title)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        video = try container.decode(Bool.self, forKey: .video)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        voteCount = try container.decode(Int.self, forKey: .voteCount)

        let poster = try container.decode(String.self, forKey: .posterPath)
        posterPath = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")!
    }

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
