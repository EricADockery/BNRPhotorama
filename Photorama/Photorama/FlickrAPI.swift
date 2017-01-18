//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Eric Dockery on 1/16/17.
//  Copyright © 2017 Eric Dockery. All rights reserved.
//

import Foundation

enum Method:String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotosResults {
    case Success([Photo])
    case Failure(Error)
}

enum FlickrError: Error {
    case InvalidJSONData
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
    return formatter
}()

private func photoFromJSONObject(json: [String:Any]) -> Photo? {
    guard let photoID = json["id"] as? String, let title = json["titl"] as? String, let dateString = json["datetaken"] as? String, let photoURLString = json["url_h"] as? String, let url = URL(string: photoURLString), let dateTaken = dateFormatter.date(from: dateString) else {
        return nil
    }
    return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
}

struct FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    static func recentPhotosURL() -> URL {
        return flickrURL(method: .RecentPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    static func photosFromJSONData(data: Data) -> PhotosResults {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            guard let jsonDictionary = jsonObject, let photos = jsonDictionary["photos"] as? [String:Any], let photosArray = photos["photo"] as? [[String:Any]] else {
                return .Failure(FlickrError.InvalidJSONData)
            }
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photoFromJSONObject(json: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            if finalPhotos.count == 0 && photosArray.count > 0 {
                return .Failure(FlickrError.InvalidJSONData)
            }
            return .Success(finalPhotos)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    private static func flickrURL( method: Method, parameters:[String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
}
