//
//  MockMovies.swift
//  MoviesAppTests
//
//  Created by Reyhan Rifqi Azzami on 17/06/22.
//

import Foundation
import RxSwift
@testable import MoviesApp

struct MockMovieAPI: ServiceType{
    typealias T = ListResponse<Movie>
    typealias R = Request
    
    func get(request: R?, Id: Int?) -> Observable<Result<T, ServiceError>> {
        guard request != nil else { return .just(.failure(.invalidRequest))}

        let result = ListResponse(page: 1, id: nil, results: MockData.movies, totalPages: 1, totalResults: MockData.movies.count)
        
        return .just(Result<T, ServiceError>.success(result))
    }
}
