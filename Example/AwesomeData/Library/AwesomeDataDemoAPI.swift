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
    
    static func fetchUnsplashImages(_ success:@escaping (_ unsplashImages: [UnsplashImage])->Void, failure:@escaping (_ message: String?)->Void){
        _ = AwesomeRequester.performRequest(unsplashListUrl, method: .GET, completion: { (data) in
            if let jsonObject = AwesomeParser.jsonObject(data) {
                let unsplashImages = UnsplashImage.parseJSONArray(jsonObject)
                UnsplashImage.save()
                
                success(unsplashImages)
            }else{
                if let data = data {
                    if let message = String(data: data,encoding: String.Encoding.utf8) {
                        failure(message)
                    }else{
                        failure("Error parsing data")
                    }
                }
            }
        })
    }
    
}
