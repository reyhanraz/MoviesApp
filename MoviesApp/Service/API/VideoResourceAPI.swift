//
//  VideoResourceAPI.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 16/06/22.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class VideoResourceAPI: ServiceHelper, ServiceType{
    typealias R = Request
    typealias T = ListResponse<Video>
    
    func get(request: Request?, Id: Int?) -> Observable<Result<T, ServiceError>> {
        guard let request = request, let id = Id else { return .just(.failure(.invalidRequest)) }

        return super.request("\(APIConfig.baseURL)/movie/\(id)/videos", method: .get, parameter: request, encoding: URLEncoding.queryString)
            .retry(3)
            .map { data, error in self.parse(data: data, error: error)}
            .asObservable()
    }
}
