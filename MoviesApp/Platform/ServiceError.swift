//
//  ServiceError.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation

enum ServiceError: Error{
    case noInternet
    case noData
    case decodingFailed
    case noVideo
    case invalidRequest
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "Please Check Your Internet Connection"
        case .noData:
            return "Failed to get data from cloud"
        case .decodingFailed:
            return "Failed to get data: Decoding Error"
        case .noVideo:
            return "Video is missing"
        case .invalidRequest:
            return "Please try again"
        }
    }
}
