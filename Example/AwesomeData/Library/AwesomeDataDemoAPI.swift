//
//  AwesomeDataDemoAPI.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 27/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit
import AwesomeData

class AwesomeDataDemoAPI: NSObject {

    static let unsplashListUrl = "https://unsplash.it/list"
    
    static func fetchUnsplashImages(success:(unsplashImages: [UnsplashImage])->Void, failure:(message: String?)->Void){
        AwesomeFetcher.fetchData(unsplashListUrl, method: .GET) { (data) in
            if let jsonObject = AwesomeParser.jsonObject(data) {
                let unsplashImages = UnsplashImage.parseJSONArray(jsonObject)
                UnsplashImage.save()
                
                success(unsplashImages: unsplashImages)
            }else{
                if let data = data {
                    if let message = String(data: data,encoding: NSUTF8StringEncoding) {
                        failure(message: message)
                    }else{
                        failure(message: "Error parsing data")
                    }
                }
            }
        }
    }
    
}
