//
//  MovieDetailViewModel.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation
import RxCocoa
import RxSwift

struct MovieDetailViewModel{
    let resultVideo: Driver<Video>
    let resultReview: Driver<[Review]>
    let failed: Driver<String>

    private let _getProperty = PublishSubject<Request?>()
    
    init<video: ServiceType, review: ServiceType>(movieID: Int, videoService: video, reviewService: review) where
        video.R == Request,
        video.T == ListResponse<Video>,
        review.R == Request,
        review.T == ListResponse<Review>
    {
        let _failed = PublishSubject<String>()

        failed = _failed.asDriver(onErrorDriveWith: .empty())
        
        resultVideo = _getProperty.asDriver(onErrorDriveWith: .empty()).flatMap({ request in
            videoService.get(request: request, Id: movieID).asDriver(onErrorDriveWith: .empty()) })
        .flatMap({ result in
            switch result{
                
            case .success(let videos):
                return .just(videos.results[0])
            case .failure(let error):
                _failed.onNext(error.localizedDescription)
            }
            return .empty()
        })
        
        resultReview = _getProperty.asDriver(onErrorDriveWith: .empty()).flatMap({ request in
            reviewService.get(request: request, Id: movieID).asDriver(onErrorDriveWith: .empty()) })
        .flatMap({ result in
            switch result{
                
            case .success(let reviews):
                return .just(reviews.results)
            case .failure(let error):
                _failed.onNext(error.localizedDescription)
            }
            return .empty()
        })
    }
    
    func get(request: Request? = Request()){
        _getProperty.onNext(request)
    }

}
