//
//  Review.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation

struct Review: Codable, Equatable {
    let author: String
    let content, id: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case content
        case id
        case url
    }
}
