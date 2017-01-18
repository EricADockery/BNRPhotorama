//
//  PhotoStore.swift
//  Photorama
//
//  Created by Eric Dockery on 1/17/17.
//  Copyright © 2017 Eric Dockery. All rights reserved.
//

import Foundation

class PhotoStore {
    //Assignment property -- not computed because it is not changing the value inside.
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchRecentPhotos(completion: @escaping (PhotosResults) -> Void) {
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processRecentPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func processRecentPhotosRequest(data: Data?, error: Error?) -> PhotosResults {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return FlickrAPI.photosFromJSONData(data: jsonData as Data)
    }
}
