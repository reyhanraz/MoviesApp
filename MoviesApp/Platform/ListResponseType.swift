//
//  ListResponseType.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation

protocol ListResponseType: Codable{
    associatedtype T
    var id: Int? { get }
    var page: Int? { get }
    var results: [T] { get }
    var totalPages: Int? { get }
    var totalResults: Int? { get }
}
