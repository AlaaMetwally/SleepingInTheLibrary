//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Geek on 1/24/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var grabbedImage: UIButton!
    
    
    @IBAction func grabNewImage(_ sender: Any) {
        setUIEnabled(false)
        getImageFromFlickr()
    }
    
    func setUIEnabled(_ enabled: Bool){
        labelView.isEnabled = enabled
        grabbedImage.isEnabled = enabled
        if enabled{
            grabbedImage.alpha = 1.0
        }else{
            grabbedImage.alpha = 0.5
        }
    }
    func getImageFromFlickr(){
        let methods = [
            Constants.FlickrParametersKeys.Method : Constants.FlickrParametersValues.GalleryPhotosMethod,
            Constants.FlickrParametersKeys.APIKey : Constants.FlickrParametersValues.GalleryAPIKey,
            Constants.FlickrParametersKeys.Format : Constants.FlickrParametersValues.GalleryFormat,
            Constants.FlickrParametersKeys.Extras : Constants.FlickrParametersValues.Medium,
            Constants.FlickrParametersKeys.GalleryID : Constants.FlickrParametersValues.GalleryID,
            Constants.FlickrParametersKeys.NoJSONCallBack : Constants.FlickrParametersValues.NoJSONCallBack
        ]
        let urlString = Constants.Flickr.FlickrAPIURL + escapedParameter(methods as [String:AnyObject])
        let session = URLSession.shared
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        let task = session.dataTask(with: request) {(data , response , error) in
            
            func displayError(_ errors: String){
                print(errors)
                print("URL at time of error: \(url)")
                performUpdatesOnMain {
                     self.setUIEnabled(true)
                }
            }
            guard let data = data else{
                displayError("No data was returned by the request!")
                return
            }
            guard (error == nil) else{
                displayError("There was an error with your request: \(error!)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,statusCode > 199 && statusCode < 300
                else{
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            let parseResult: [String:AnyObject]!
            do{
                 parseResult = try (JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject])
            }
            catch{
                displayError("Could not parse data as JSON: '\(data)'")
                return
            }
            
            guard let photoDictionary = parseResult![Constants.FlickrResponse.photos] as? [String:AnyObject] , let photoArray = photoDictionary[Constants.FlickrResponse.photo] as? [[String:AnyObject]] else {
                displayError("Cannot find keys '\(Constants.FlickrResponse.photos)' and '\(Constants.FlickrResponse.photo)' in \(parseResult)")
                return
            }
            guard let status = parseResult[Constants.FlickrResponse.status] as? String, status == Constants.Flickrstats.stats
                else{
                displayError("Flickr API returned an error. See error code and message in \(parseResult)")
                return
            }
            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            let imageUrl = URL(string: photoArray[randomPhotoIndex][Constants.FlickrResponse.mediumURL] as! String)
                if let imageData = try? Data(contentsOf: imageUrl!) {
                    performUpdatesOnMain {
                        self.setUIEnabled(true)
                        self.imageView.image = UIImage(data: imageData)
                        self.labelView.text = photoArray[randomPhotoIndex][Constants.FlickrResponse.title] as! String
                    }
                }
            }
        task.resume()
    }
    
    private func  escapedParameter(_ methods: [String:AnyObject]) -> String{
        
        if methods.isEmpty{
            return ""
        }else{
            var keyPair = [String]()
            for(key, value) in methods {
                let stringValue = "\(value)"
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                keyPair.append("\(key)=\(escapedValue!)")
            }
            return "?\(keyPair.joined(separator: "&"))"
        }
    }
}

