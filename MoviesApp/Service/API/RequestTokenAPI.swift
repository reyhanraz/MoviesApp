//
//  RequestTokenAPI.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi on 27/06/22.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class RequestTokenAPI: ServiceHelper, ServiceType{
    
    typealias R = Request
    typealias T = Response
    
    func get(request: Request?, Id: Int?) -> Observable<Result<Response, ServiceError>> {
        return super.request("\(APIConfig.baseURL)\(APIConfig.requestToken)", method: .get, parameter: request, encoding: URLEncoding.queryString)
            .retry(3)
            .map { data, error in self.parse(data: data, error: error)}
            .asObservable()
    }
}
