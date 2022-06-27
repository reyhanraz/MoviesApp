//
//  ViewController.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import UIKit
import RxSwift
import RxCocoa

class ListMovieViewController: BaseViewController {
    private let _cellIdentifier = "PosterCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    var refresher: UIRefreshControl!
    let viewModel = MovieListViewModel(service: MovieAPI())
    private var _request = Request(page: 1)
    private var _itemsCount = 0
    
    let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
        
        navigationItem.rightBarButtonItem = profileButton
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        setupView()
        
        binding()
        
        loadData()
    }
    
    @objc private func loadData(){
        viewModel.get(request: _request)
    }
    
    func setupView(){
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refresher

        collectionView.register(MoviePostersCollectionViewCell.self, forCellWithReuseIdentifier: _cellIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
                
        let itemWidth = UIScreen.main.bounds.size.width
        
        layout.itemSize = CGSize(width: itemWidth, height: 200)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func binding(){
        profileButton.rx.tap.subscribe(onNext: { _ in
            let vc = AccountViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        viewModel.result.drive(collectionView.rx.items(cellIdentifier: _cellIdentifier, cellType: MoviePostersCollectionViewCell.self)){ row, model, cell in
            cell.setupContent(imageUrl: model.posterPath, movieTitle: model.title)
        }.disposed(by: disposeBag)
        
        viewModel.itemsCount.drive(onNext: { [weak self] count in
            self?._itemsCount = count
            self?.collectionView.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell.subscribe(onNext: {[weak self] cell, indexPath in
            
            if indexPath.row == (self?._itemsCount ?? 0) - 2 {
                self?.loadMore()
            }
            
        }).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Movie.self).subscribe(onNext:{[weak self] movie in
            let vc = DetailMovieViewController(movie: movie)
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        viewModel.loading.asObservable().subscribe(onNext: {[weak self] start in
            if start {
                self?.refresher.beginRefreshing()
            } else {
                self?.refresher.endRefreshing()
            }
        }).disposed(by: disposeBag)
        
        viewModel.failed.drive(rx.failed).disposed(by: disposeBag)
    }
    
    private func loadMore(){
        let page = (_request.page ?? 0) + 1
        _request.page = page
        viewModel.loadMore(request: _request)
    }

}
