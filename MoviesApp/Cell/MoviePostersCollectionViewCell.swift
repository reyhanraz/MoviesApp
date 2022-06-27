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
        v.textAlignment = .left
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
            imgCover.widthAnchor.constraint(equalToConstant: 150),
            imgCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: imgCover.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imgCover.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
    }
    
    public func setupContent(imageUrl: URL?, movieTitle: String?){
        imgCover.loadMedia(url: imageUrl, failure: UIImage(named: "failed"))
        titleLabel.text = movieTitle
    }
}
