//
//  ServiceType.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation
import RxSwift

protocol ServiceType{
    associatedtype T
    associatedtype R

    func get(request: R?, Id: Int?) -> Observable<Result<T, ServiceError>>
}

extension ServiceType{
    func parse<T: Codable> (data: Data?, error: ServiceError?) -> Result<T,ServiceError>{
        guard error == nil else { return .failure(error!)}
        guard let data = data else { return .failure(.noData) }
        guard let model = try? JSONDecoder().decode(T.self, from: data) else { return .failure(.decodingFailed)}
        
        return .success(model)
    }
}
