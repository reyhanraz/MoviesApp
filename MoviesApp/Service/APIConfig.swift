//
//  APIConfig.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation

struct APIConfig{
    static let apiKey = "d4bce3097f0333947d4669ebdbdaf618"
    
    static let baseURL = "https://api.themoviedb.org/3"
    
    //MARK: - EndPoint
    static let requestToken = "/authentication/token/new"
    static let createSession = "/authentication/session/new"
    let getVideoResource = "/movie/338953/videos"
    let youtube = "https://www.youtube.com/embed/Fo6TfHkLW6Y"
    
    enum EndPoint{
        case getReview(movieID: Int)
        case getListMovie
        case getVideoResource(movieID: Int)
    }
    
}

protocol RequestType: Codable{
    var api_key: String? { get }
    var language: String? { get }
    var page: Int? { get }
}

struct Request: RequestType{
    var api_key: String?
    var language: String?
    var page: Int?
    
    init(apiKey: String? = APIConfig.apiKey, language: String? = "en-US", page: Int? = nil){
        self.api_key = apiKey
        self.language = language
        self.page = page
    }
}

