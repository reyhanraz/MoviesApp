//
//  ReviewAPI.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 16/06/22.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class ReviewAPI: ServiceHelper, ServiceType{
    typealias R = Request
    typealias T = ListResponse<Review>
    
    func get(request: Request?, Id: Int?) -> Observable<Result<T, ServiceError>> {
        guard let request = request, let id = Id else { return .just(.failure(.invalidRequest)) }
        
        return super.request("\(APIConfig.baseURL)/movie/\(id)/reviews", method: .get, parameter: request, encoding: URLEncoding.queryString)
            .retry(3)
            .map { data, error in self.parse(data: data, error: error)}
            .asObservable()
    }
}
