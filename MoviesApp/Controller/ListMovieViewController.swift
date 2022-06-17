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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        setupView()
        
        binding()
        
        // Do any additional setup after loading the view.
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
        let collectionViewInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                
        let marginsAndInset = collectionViewInset.left + collectionViewInset.right + layout.minimumInteritemSpacing * CGFloat(3 - 1)
        let itemWidth = ((UIScreen.main.bounds.size.width - marginsAndInset) / CGFloat(3)).rounded(.down)
        
        layout.itemSize = CGSize(width: itemWidth, height: 250)
                
        let max = 3
        
        let marginsAndInsets = (collectionViewInset.right + collectionViewInset.left) / 2 + layout.minimumInteritemSpacing * CGFloat(max - 1)
        let totalCellWidth = layout.itemSize.width * CGFloat(max)
        
        let inset = (UIScreen.main.bounds.size.width - (totalCellWidth + marginsAndInsets)) / 2
        
        layout.sectionInset = UIEdgeInsets(top: collectionViewInset.top, left: inset, bottom: collectionViewInset.bottom, right: inset)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func binding(){
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
