//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Eric Dockery on 4/9/17.
//  Copyright © 2017 Eric Dockery. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!

    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateWithImage(image: nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(image: nil)
    }
    
}
