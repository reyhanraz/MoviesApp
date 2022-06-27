//
//  CreateSessionAPI.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi on 27/06/22.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class CreateSessionAPI: ServiceHelper, ServiceType{

    
    typealias R = CreateSessionRequest
    typealias T = Response
    
    func get(request: R?, Id: Int?) -> Observable<Result<Response, ServiceError>> {
        guard let request = request else { return .just(.failure(.invalidRequest)) }

        return super.request("\(APIConfig.baseURL)\(APIConfig.createSession)", method: .post, parameter: request, encoding: URLEncoding.httpBody)
            .retry(3)
            .map { data, error in self.parse(data: data, error: error)}
            .asObservable()
    }

}

struct CreateSessionRequest: Codable{
    let request_token: String
}
