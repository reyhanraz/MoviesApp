//
//  VideoResource.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation

struct Video: Codable, Equatable {
    let name, key: String
    let site: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name, key, site
        case id
    }
}
