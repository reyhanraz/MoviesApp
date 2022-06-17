//
//  UIImageView+Nuke.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Nuke

public extension UIImageView {
    
    func loadMedia(url: URL?, thumb: URL? = nil, placeholder: UIImage? = nil, failure: UIImage? = nil) {
        guard let url = url else {
            image = failure
            
            return
        }
        
        Nuke.loadImage(
            with: url,
            options: ImageLoadingOptions(
                placeholder: placeholder,
                transition: .fadeIn(duration: 0.33),
                failureImage: failure,
                contentModes: ImageLoadingOptions.ContentModes(success: .scaleAspectFill, failure: .scaleAspectFill, placeholder: .scaleAspectFill)
        ), into: self)
        
    }
}
