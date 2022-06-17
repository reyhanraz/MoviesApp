//
//  MovieListViewModelTest.swift
//  MoviesAppTests
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import MoviesApp

class MovieListViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    var viewModel: MovieListViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    var testScheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        viewModel = MovieListViewModel(service: MockMovieAPI())
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

    func testFirstLoadMovie() {
        let observer1 = testScheduler.createObserver([Movie].self)

        testScheduler.scheduleAt(200) {
            self.viewModel.result.drive(observer1).disposed(by: self.disposeBag)
        }
        
        testScheduler.scheduleAt(220) {
            self.viewModel.get(request: Request())
        }
        
        testScheduler.start()
        
        XCTAssertRecordedElements(observer1.events, [MockData.movies])
    }
    
    func testLoadMoreMovie() {
        let observer1 = testScheduler.createObserver([Movie].self)

        testScheduler.scheduleAt(200) {
            self.viewModel.result.drive(observer1).disposed(by: self.disposeBag)
        }
        
        testScheduler.scheduleAt(220) {
            self.viewModel.get(request: Request())
        }
        
        testScheduler.scheduleAt(230) {
            self.viewModel.loadMore(request: Request())
        }
        
        testScheduler.start()
        
        XCTAssertRecordedElements(observer1.events, [MockData.movies, MockData.movies+MockData.movies])
    }
    
    func testInvalidRequest() {
        let result = testScheduler.createObserver([Movie].self)
        let failed = testScheduler.createObserver(String.self)

        testScheduler.scheduleAt(200) {
            self.viewModel.result.drive(result).disposed(by: self.disposeBag)
            self.viewModel.failed.drive(failed).disposed(by: self.disposeBag)

        }
        
        testScheduler.scheduleAt(220) {
            self.viewModel.get(request: nil)
        }
        
        testScheduler.start()
        
        XCTAssertRecordedElements(result.events, [])
        XCTAssertEqual(failed.events, [.next(220, "Please try again")])
    }
    
    func testLoadMoreMovieInvalidRequest() {
        let result = testScheduler.createObserver([Movie].self)
        let failed = testScheduler.createObserver(String.self)

        testScheduler.scheduleAt(200) {
            self.viewModel.result.drive(result).disposed(by: self.disposeBag)
            self.viewModel.failed.drive(failed).disposed(by: self.disposeBag)

        }
        
        testScheduler.scheduleAt(210) {
            self.viewModel.get(request: Request())
        }
        
        testScheduler.scheduleAt(220) {
            self.viewModel.loadMore(request: nil)
        }
        
        testScheduler.start()
        
        XCTAssertRecordedElements(result.events, [MockData.movies])
        XCTAssertEqual(failed.events, [.next(220, "Please try again")])
    }

}
