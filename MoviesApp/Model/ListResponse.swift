//
//  ListResponse.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation

struct ListResponse<T: Codable>: ListResponseType{
    let page: Int?
    let id: Int?
    let results: [T]
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
