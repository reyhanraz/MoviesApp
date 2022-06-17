//
//  YoutubePlayerTableViewCell.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import UIKit
import youtube_ios_player_helper

class YoutubePlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerView: YTPlayerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        playerView.delegate = self

    }
    
    func setupContent(videoID: String){
        playerView.load(withVideoId: videoID, playerVars: ["playsinline": 1])
    }
    
}

extension YoutubePlayerTableViewCell: YTPlayerViewDelegate{
    
}
