//
//  MovieListViewModel.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation
import RxSwift
import RxCocoa

struct MovieListViewModel{
    let result: Driver<[Movie]>
    let loading: Driver<Bool>
    let failed: Driver<String>
    let itemsCount: Driver<Int>

    
    private let _getListProperty = PublishSubject<Request?>()
    private let _loadMoreProperty = PublishSubject<Request?>()
    
    init<S: ServiceType>(service: S) where S.R == Request, S.T == ListResponse<Movie>{
        let _loading = PublishSubject<Bool>()
        let _failed = PublishSubject<String>()
        let _itemsCount = PublishSubject<Int>()

        
        loading = _loading.asDriver(onErrorDriveWith: .empty())
        failed = _failed.asDriver(onErrorDriveWith: .empty())
        itemsCount = _itemsCount.asDriver(onErrorDriveWith: .empty())

        var items = [Movie]()

        
        let initial: Driver<[Movie]>  = _getListProperty.asDriver(onErrorDriveWith: .empty())
            .do(onNext: { _ in _loading.onNext(true) })
            .flatMap({ request in
                service.get(request: request, Id: nil).map { (request, $0) }.asDriver(onErrorDriveWith: .empty()) })
            .do(onNext: { _ in _loading.onNext(false) })
            .flatMap({ request, result in
            switch result{
                
            case .success(let movie):
                return .just(movie.results)
            case .failure(let error):
                _failed.onNext(error.localizedDescription)
            }
            return .empty()
        })
                
        let nextRequest: Driver<[Movie]> = _loadMoreProperty
        .asDriver(onErrorDriveWith: .empty())
        .do(onNext: { _ in _loading.onNext(true) })
        .flatMap { request in
            return service.get(request: request, Id: nil).map { (request, $0) }.asDriver(onErrorDriveWith: .empty())
        }
        .do(onNext: { _ in _loading.onNext(false) })
        .flatMap({ result in
            switch result.1 {
            case let .success(list):
                return .just(list.results)
            case .failure(let error):
                _failed.onNext(error.localizedDescription)
            }
            return .empty()
        })
            
        result = Driver.merge(initial, nextRequest).map({ result in
            
            items += result
            
            _itemsCount.onNext(items.count)
            
            return items
        })
        
        
    }
    
    public func get(request: Request?) {
        _getListProperty.onNext(request)
    }
    
    public func loadMore(request: Request?) {
        _loadMoreProperty.onNext(request)
    }
    
    
}
