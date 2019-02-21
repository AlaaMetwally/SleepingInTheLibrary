//
//  Constants.swift
//  SleepingInTheLibrary
//
//  Created by Geek on 1/24/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import Foundation

struct Constants{
    struct  Flickr {
        static let FlickrAPIURL = "https://api.flickr.com/services/rest/"
    }
    struct FlickrParametersKeys{
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallBack = "nojsoncallback"
        static let AuthToken = "auth_token"
        static let APISig = "api_sig"
    }
    struct FlickrParametersValues{
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let GalleryAPIKey = "32d485de3982dfce4b7ad83b74764a4b"
        static let GalleryID = "72157688996270423"
        static let Medium = "url_m"
        static let GalleryFormat = "json"
        static let NoJSONCallBack = "1"
    }
    struct FlickrResponse{
        static let photo = "photo"
        static let photos = "photos"
        static let mediumURL = "url_m"
        static let title = "title"
        static let status = "stat"
    }
    struct Flickrstats {
        static let stats = "ok"
    }
}
