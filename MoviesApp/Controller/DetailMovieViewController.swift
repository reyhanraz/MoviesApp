//
//  DetailMovieViewController.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import UIKit
import RxSwift

class DetailMovieViewController: BaseViewController {
    
    private let _movieCell = "MovieCell"
    private let _playerCell = "PlayerCell"
    private let _reviewCell = "ReviewCell"
    
    private let _movie: Movie
    
    private var _reviews = [Review]()
    private var _video: Video?
    
    private var viewModel: MovieDetailViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    init(movie: Movie) {
        _movie = movie
        super.init(nibName: "DetailMovieViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movie Detail"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MovieInfoTableViewCell", bundle: nil), forCellReuseIdentifier: _movieCell)
        tableView.register(UINib(nibName: "YoutubePlayerTableViewCell", bundle: nil), forCellReuseIdentifier: _playerCell)
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: _reviewCell)
        
        binding()

        loadData()
    }
    
    private func binding(){
        let _viewModel = MovieDetailViewModel(movieID: _movie.id, videoService: VideoResourceAPI(), reviewService: ReviewAPI())
        viewModel = _viewModel
        
        viewModel?.resultReview.drive(onNext: { reviews in
            self._reviews = reviews
        }).disposed(by: disposeBag)
        
        viewModel?.resultReview.drive(onNext: { reviews in
            self._reviews = reviews
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel?.resultVideo.drive(onNext: { video in
            self._video = video
        }).disposed(by: disposeBag)
        
        viewModel?.failed.drive(rx.failed).disposed(by: disposeBag)
        
    }
    
    private func loadData(){
        viewModel?.get()
    }


}

extension DetailMovieViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        return _reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: _movieCell, for: indexPath) as! MovieInfoTableViewCell
            cell.setupContent(imageUrl: _movie.posterPath, rating: _movie.voteAverage, description: _movie.overview)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: _playerCell, for: indexPath) as! YoutubePlayerTableViewCell
            cell.setupContent(videoID: _video?.key ?? "")
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: _reviewCell, for: indexPath) as! ReviewTableViewCell
            let review = _reviews[indexPath.row]
            cell.setupContent(username: review.author, comment: review.content)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return _movie.title
        } else if section == 1 {
            return "Trailer"
        } else {
            return "Review"
        }
    }
    
}
