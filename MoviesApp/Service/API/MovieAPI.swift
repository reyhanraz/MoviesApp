//
//  MovieAPI.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class MovieAPI: ServiceHelper, ServiceType{
    typealias R = Request
    typealias T = ListResponse<Movie>
    
    func get(request: Request?, Id: Int?) -> Observable<Result<T, ServiceError>> {
        guard let request = request else { return .just(.failure(.invalidRequest)) }
        
        return super.request("\(APIConfig.baseURL)/discover/movie", method: .get, parameter: request, encoding: URLEncoding.queryString)
            .retry(3)
            .map { data, error in self.parse(data: data, error: error)}
            .asObservable()
    }
}
