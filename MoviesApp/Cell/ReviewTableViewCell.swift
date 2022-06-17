//
//  ReviewTableViewCell.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentReviewLabel: UILabel!

    func setupContent(username: String?, comment: String?){
        userNameLabel.text = username
        commentReviewLabel.text = comment
    }
    
}
