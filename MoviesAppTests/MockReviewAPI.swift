//
//  MockReviewAPI.swift
//  MoviesAppTests
//
//  Created by Reyhan Rifqi Azzami on 17/06/22.
//

import Foundation
import RxSwift
@testable import MoviesApp

struct MockReviewAPI: ServiceType{
    typealias T = ListResponse<Review>
    typealias R = Request
    
    func get(request: R?, Id: Int?) -> Observable<Result<T, ServiceError>> {
        guard let id = Id, request != nil else {
            return .just(.failure(.invalidRequest))
        }


        let result = ListResponse(page: 1, id: id, results: MockData.review, totalPages: 1, totalResults: MockData.review.count)
        
        return .just(Result<T, ServiceError>.success(result))
    }
}
