//
//  ViewModel.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi on 27/06/22.
//

import Foundation
import RxSwift
import RxCocoa
struct ViewModel<DataRequest: Codable, DataResponse: Codable> {
    public typealias Request = DataRequest
    public typealias Response = DataResponse
    
    // MARK: Outputs
    public let result: Driver<DataResponse>
    public let loading: Driver<Bool>
    public let failed: Driver<String>

    
    // MARK: Private
    private let _requestProperty = PublishSubject<DataRequest?>()
    
    public init<Service: ServiceType>(service: Service) where Service.R == DataRequest, Service.T == DataResponse {
        
        let loadingProperty = PublishSubject<Bool>()
        let failedProperty = PublishSubject<String>()
        
        loading = loadingProperty.asDriver(onErrorJustReturn: false)
        failed = failedProperty.asDriver(onErrorDriveWith: .empty())
                
        result = _requestProperty
            .asDriver(onErrorDriveWith: .empty())
            .do(onNext: { _ in loadingProperty.onNext(true) })
            .flatMap { request in
                return service.get(request: request, Id: nil).asDriver(onErrorDriveWith: .empty())
        }
        .do(onNext: { _ in loadingProperty.onNext(false) })
        .flatMap({ result in
            switch result{
            case .success(let data):
                return .just(data)
            case .failure(let error):
                failedProperty.onNext(error.localizedDescription)
            }
            return .empty()
        })
    }
    
    public func execute(request: DataRequest? = nil) {
        _requestProperty.onNext(request)
    }
}
