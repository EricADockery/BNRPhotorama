//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Eric Dockery on 4/10/17.
//  Copyright © 2017 Eric Dockery. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchImageForPhoto(photo: photo) { (result) in
            switch result {
            case let .Success(image):
                OperationQueue.main.addOperation {
                    self.imageView.image = image
                }
            case let .Failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
}
