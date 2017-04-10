//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Eric Dockery on 1/15/17.
//  Copyright © 2017 Eric Dockery. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        stupCollectionlayout()
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            OperationQueue.main.addOperation {
                switch photosResult {
                case let .Success(photos):
                    self.photoDataSource.photos = photos
                case let .Failure(error):
                    self.photoDataSource.photos.removeAll()
                    print("Error fetching recent photos: \(error)")
                }
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }

    func stupCollectionlayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let size = 90
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        collectionView!.collectionViewLayout = layout
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        store.fetchImageForPhoto(photo: photo) { (result) in
            OperationQueue.main.addOperation {
                if let photoIndex = self.photoDataSource.photos.index(of: photo) {
                    let photoIndexPath = IndexPath(row: photoIndex, section: 0)
                    if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                        cell.updateWithImage(image: photo.image)
                    }
                }
            }
        }
    }
}
