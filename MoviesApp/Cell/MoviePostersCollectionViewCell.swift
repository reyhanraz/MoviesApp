//
//  MoviePostersCollectionViewCell.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import UIKit

class MoviePostersCollectionViewCell: UICollectionViewCell {
    lazy var imgCover: UIImageView = {
        let v = UIImageView()
        
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        
        v.clipsToBounds = true
        v.textAlignment = .center
        v.numberOfLines = 0
        v.font = v.font.withSize(14)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(imgCover)
        contentView.addSubview(titleLabel)
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
        
        NSLayoutConstraint.activate([
            imgCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgCover.heightAnchor.constraint(equalToConstant: self.frame.width / 2 * 3),
            
            titleLabel.topAnchor.constraint(equalTo: imgCover.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
    }
    
    public func setupContent(imageUrl: URL?, movieTitle: String?){
        imgCover.loadMedia(url: imageUrl, failure: UIImage(named: "failed"))
        titleLabel.text = movieTitle
    }
}
