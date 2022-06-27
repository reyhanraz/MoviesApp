//
//  Response.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi on 27/06/22.
//

import Foundation

struct Response: Codable{
    let success: Bool
    let expires_at: String?
    let request_token: String?
    let session_id: String?
}
