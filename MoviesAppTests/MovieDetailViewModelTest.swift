//
//  MovieDetailViewModelTest.swift
//  MoviesAppTests
//
//  Created by Reyhan Rifqi Azzami on 17/06/22.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import MoviesApp

class MovieDetailViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    var viewModel: MovieDetailViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    var testScheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        viewModel = MovieDetailViewModel(movieID: 12343, videoService: MockVideoAPI(), reviewService: MockReviewAPI())
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        scheduler = nil
        testScheduler = nil
        super.tearDown()
    }

    func testLoadReview() {
        let observer1 = testScheduler.createObserver([Review].self)

        testScheduler.scheduleAt(200) {
            self.viewModel.resultReview.drive(observer1).disposed(by: self.disposeBag)
        }
        
        testScheduler.scheduleAt(220) {
            self.viewModel.get(request: Request())
        }
        
        testScheduler.start()
        
        XCTAssertRecordedElements(observer1.events, [MockData.review])
    }
    
    func testLoadVideo() {
        let observer1 = testScheduler.createObserver(Video.self)

        testScheduler.scheduleAt(200) {
            self.viewModel.resultVideo.drive(observer1).disposed(by: self.disposeBag)
        }
        
        testScheduler.scheduleAt(220) {
            self.viewModel.get(request: Request())
        }
        
        testScheduler.start()
        
        XCTAssertRecordedElements(observer1.events, [MockData.videos[0]])
    }
    
    func testInvalidRequest() {
        let review = testScheduler.createObserver([Review].self)
        let video = testScheduler.createObserver(Video.self)
        let failed = testScheduler.createObserver(String.self)

        testScheduler.scheduleAt(200) {
            self.viewModel.resultReview.drive(review).disposed(by: self.disposeBag)
            self.viewModel.resultVideo.drive(video).disposed(by: self.disposeBag)
            self.viewModel.failed.drive(failed).disposed(by: self.disposeBag)
        }
        
        testScheduler.scheduleAt(220) {
            self.viewModel.get(request: nil)
        }
        
        testScheduler.start()
        
        XCTAssertRecordedElements(review.events, [])
        XCTAssertRecordedElements(video.events, [])
        XCTAssertEqual(failed.events, [.next(220, "Please try again"), .next(220, "Please try again")])
    }

}
