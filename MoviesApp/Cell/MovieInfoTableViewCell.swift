//
//  MovieInfoTableViewCell.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import UIKit

class MovieInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var moviePosterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        moviePosterImage.clipsToBounds = true
        moviePosterImage.layer.cornerRadius = 5
    }

    func setupContent(imageUrl: URL?, rating: Double, description: String?){
        movieTitleLabel.text = "Rate: \(rating) / 10"
        movieDescriptionLabel.text = description
        moviePosterImage.loadMedia(url: imageUrl, failure: UIImage(named: "failed"))
    }
    
}
