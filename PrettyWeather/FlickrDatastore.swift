//
//  FlickrDatastore.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 25.10.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import FlickrKit

class FlickrDatastore {
    
    private let OBJECTIVE_FLICKR_API_KEY = "ba69e3dc2e84bbe163fb3cde9b0ed8bb"
    private let OBJECTIVE_FLICKR_API_SHARED_SECRET = "2fd9482abce69b1e"
    private let GROUP_ID = "1463451@N25"
    
    func retrieveImageAtLat(lat: Double, lon: Double, closure: @escaping (_ image: UIImage?) -> Void ){
        let fk = FlickrKit.shared()
        
        fk?.initialize(withAPIKey: OBJECTIVE_FLICKR_API_KEY, sharedSecret: OBJECTIVE_FLICKR_API_SHARED_SECRET)
        
        
        fk?.call("flickr.photos.search", args: ["group_id": GROUP_ID, "lat": "\(lat)", "lon": "\(lon)", "radius": "10"], maxCacheAge: FKDUMaxAgeOneHour, completion: { (response, error) -> Void in
            
            if let unwrfk = fk {
                self.extractImageFk(fk: unwrfk, response: response as AnyObject?, error: error as NSError?, closure: closure)
            }
            else{
                return
            }
            
            }
        )
    }
    
    private func extractImageFk(fk: FlickrKit, response: AnyObject?,
                                error: NSError?, closure: @escaping (_ image: UIImage?) -> Void){
      
        if let response = response as? [String:AnyObject] {
            if let photos = response["photos"] as? [String:AnyObject]{
                if let listOfPhotos: AnyObject = photos["photo"] {
                    if listOfPhotos.count > 0 {
                        
                         let randomIndex = Int(arc4random_uniform(UInt32(listOfPhotos.count)))
                         let photo = listOfPhotos[randomIndex] as![String:AnyObject]
                         if let url = fk.photoURL(for: FKPhotoSizeMedium640, fromPhotoDictionary: photo) {
                            
                            do {
                               let image = try UIImage(data: NSData(contentsOf: url) as Data)
                            
                                
                                DispatchQueue.main.async {
                                    closure(image!)
                                }
                                
                            }
                            catch{
                            print("no image")
                            }
                            
                            
                            
                         }
                    }
                }
            }
        }
        else {
            print(error)
            print(response)
        }
        
        
    }
    
}
